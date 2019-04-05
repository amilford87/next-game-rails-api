require 'geocoder'

class Api::NextGamesController < ApplicationController

  # Methods not complete
  def index
    @user = User.find(current_user.id)
    @current_location = {location: {lat: params[:lat].to_f, lng: params[:lng].to_f}}
    @sports = @user.sports
    @timeprefs = @user.timeprefs

    existing_games = find_existing_games()

    new_games = find_new_games()

    next_games = existing_games.concat new_games
    apply_game_weight(next_games).sort! { |x,y| y[:weighted_score] <=> x[:weighted_score]}
    next_games = next_games.slice(0, 5)
    render json: next_games, status: 200
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
            time: g.start_time.strftime("%I:%M %p"),
            gameId: g.id
          }
          existing_games.push(existing_game)
        end
      end
    end
    existing_games
  end

  def find_new_games()
    empty_games = {}
    @sports.each do |sport|
      empty_games[sport.name] = []
      facilities = sport.facilities
      facilities.each do |f|
        new_game = {
          type: 'new',
          date: 'USER PREF HERE',
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
          time: "USER PREF HERE"
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
      distance_weight = (2.5 * Math.tanh(2.5 - (1.4 * Math.sqrt(g[:dist]))) + 2.5) # ((-0.75 * g[:dist]) + 5)
      if distance_weight < 0 then distance_weight = 0 end
      # y=2.5 * tanh(2.5-1.3 * sqrt{x})+2.5
      # Players
      player_weight = 1.3 * g[:other_players].count
      if player_weight > 7.5 then player_weight = 7.5 end
      g[:weighted_score] = (distance_weight + player_weight).round(3)
    end
    games
  end

  def validate_by_time_prefs(game)
    is_valid_date_time = false
    if @timeprefs.count == 0
      is_valid_date_time = true
    else
      @timeprefs.each do |tp|
        if ((tp.week_day == game.date.strftime("%A")) && ((tp.start_time..tp.end_time).cover? game.start_time))
          is_valid_date_time = true
        end
      end
    end
    is_valid_date_time
  end
end
