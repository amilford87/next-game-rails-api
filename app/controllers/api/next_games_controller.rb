require 'geocoder'

class Api::NextGamesController < ApplicationController

  # Show a user possible next games
  def index

    if @user = User.find(current_user.id)
      @user = User.find(current_user.id)
      @current_location = {location: {lat: params[:lat].to_f, lng: params[:lng].to_f}}
      @sports = @user.sports
      @timeprefs = @user.timeprefs.where(active: true)

      existing_games = find_existing_games()

      new_games = find_new_games()

      next_games = existing_games.concat new_games
      apply_game_weight(next_games).sort! { |x,y| y[:weighted_score] <=> x[:weighted_score]}
      next_games = next_games.slice(0, 10)

      render json: next_games, status: 200
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  private

  def find_existing_games()
    existing_games = []
    @sports.each do |sport|
      games = sport.games
      games.each do |g|
        if validate_by_time_prefs(g)
          existing_game = {
            type: 'active',
            date: g.date.strftime("%A %d of %B %Y"),
            image: g.sport.image,
            location: {
              lat: g.facility.latitude.to_f,
              lng: g.facility.longitude.to_f
            },
            dist: (Geocoder::Calculations.distance_between([@current_location[:location][:lat], @current_location[:location][:lng]], [g.facility.latitude.to_f, g.facility.longitude.to_f]) * 1.60934).round(2),
            facility: g.facility.name,
            other_players: g.users.ids,
            sport: g.sport.name,
            time: g.start_time.strftime("%H:%M"),
            gameId: g.id
          }
          existing_games.push(existing_game)
        end
      end
    end
    remove_owned_games(existing_games)
  end

  def find_new_games()
    empty_games = {}
    @sports.each do |sport|
      empty_games[sport.name] = []
      facilities = sport.facilities
      facilities.each do |f|
        new_date = get_new_game_time()
        new_game = {
          type: 'new',
          date: new_date[:date],
          image: sport.image,
          location: {
            lat: f.latitude.to_f,
            lng: f.longitude.to_f
          },
          dist: (Geocoder::Calculations.distance_between([@current_location[:location][:lat], @current_location[:location][:lng]], [f.latitude.to_f, f.longitude.to_f]) * 1.60934).round(2),
          facility: f.name,
          facilityId: f.id,
          other_players: [],
          sport: sport.name,
          sportId: sport.id,
          time: new_date[:time]
        }
        empty_games[sport.name].push(new_game)
      end
      empty_games[sport.name].sort! { |x,y| x[:dist] <=> y[:dist]}
      if empty_games[sport.name].count > 2
        empty_games[sport.name] = empty_games[sport.name].slice(0,2)
      end
    end
    new_games = []
    empty_games.each_value do |s|
      s.each do |eg|
        new_games.push(eg)
      end
    end
    new_games
  end

  def apply_game_weight(games)
    games.each do |g|
      # Distance
      distance_weight = (4.5 * Math.tanh(3.5 - (1.5 * Math.sqrt(0.9 * g[:dist]))) + 1.5)
      if g[:dist] > 15 then distance_weight = -6 end
      # Players
      player_weight = 1.3 * g[:other_players].count
      if player_weight > 6 then player_weight = 6 end
      g[:weighted_score] = (distance_weight + player_weight).round(3)
    end
    games
  end

  def validate_by_time_prefs(game)
    is_valid_date_time = false
    date_time = epoch_time(game.date, game.start_time)
    if (date_time - Time.now.strftime("%s").to_i) > -1800
      if @timeprefs.count == 0
        is_valid_date_time = true
      else
        @timeprefs.each do |tp|
          if ((tp.week_day == (game.date.strftime("%A")).downcase) &&
          (((tp.start_time..tp.end_time).cover? game.start_time) ||
          (((tp.start_time - tp.end_time) > 0) && ((game.start_time - tp.start_time) > 0))))
            is_valid_date_time = true
          end
        end
      end
    end
    is_valid_date_time
  end

  def remove_owned_games(games)
    owned_games = @user.games.ids
    owned_games.each do |i|
      game_index = games.index { |g| g[:gameId] == i }
      if game_index
        games.slice!(game_index)
      end
    end
    games
  end

  def epoch_time(date, time)
    seconds = date.strftime("%s").to_i
    seconds += time.strftime("%H").to_i * 3600
    seconds += time.strftime("%M").to_i * 60
  end

  def get_new_game_time()
    if @timeprefs.count < 1
      new_time = Time.now + 3600
      new_time -= (new_time.sec + new_time.min % 30 * 60)
      if (new_time.strftime("%s").to_i - Time.now.strftime("%s").to_i) < 3600
        new_time += 1800
      end
      new_game_time = {
        date: Date.today.strftime("%A %d of %B %Y"),
        time: new_time.strftime("%H:%M")
      }
    else
      epoch_dates = []
      @timeprefs.each do |tp|
        epoch_stamp = {
          tp_id: tp.id,
          seconds: epoch_time(Date.parse(tp.week_day), tp.start_time)
        }
        epoch_dates.push(epoch_stamp)
      end
      epoch_dates.sort! { |x,y| x[:seconds] <=> y[:seconds] }
      epoch_dates.count.times do
        if epoch_dates[0][:seconds] < Time.now.strftime("%s").to_i
          epoch_dates[0][:seconds] += 604800
          epoch_dates.push(epoch_dates.delete(epoch_dates[0]))
        end
      end
      new_game_time = {
        date: Time.at(epoch_dates[0][:seconds]).to_datetime.strftime("%A %d of %B %Y"),
        time: (@timeprefs.select { |d| d[:id] == epoch_dates[0][:tp_id] })[0][:start_time].strftime("%H:%M")
      }
    end
  end
end
