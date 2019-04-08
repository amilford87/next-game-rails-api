class Api::GamesController < ApplicationController

  # Get users existing games
  def index
    if @user = User.find(current_user.id)
      @current_games = @user.games
      @current_location = {location: {lat: params[:lat].to_f, lng: params[:lng].to_f}}
      @user_current_games_data = []
      @user.games.each do |game|
        @game_sport = game.sport.name
        @game_image = game.sport.image
        @game_facility_name = game.facility.name
        @game_facility_lat = game.facility.latitude
        @game_facility_lng = game.facility.longitude
        @game_other_players = []
        game.user_ids.each do |user|
          @my_games_usernames = User.find(user).username
          @game_other_players.push(@my_games_usernames)
        end
        @users_saved_games = { other_players: @game_other_players.count,
                               date: game.date.strftime("%A %d of %B %Y"),
                               time: game.start_time.strftime("%I:%M %p"),
                               sport: @game_sport,
                               image: @game_image,
                               facility: @game_facility_name,
                               location: {lat: @game_facility_lat.to_f, lng: @game_facility_lng.to_f},
                               dist: (Geocoder::Calculations.distance_between([@current_location[:location][:lat], @current_location[:location][:lng]], [@game_facility_lat.to_f, @game_facility_lng.to_f]) * 1.60934).round(1),
                               id: game.id
                       }
      @user_current_games_data.push(@users_saved_games)
      end
      render json: @user_current_games_data, status: 200
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  # Create a new game for a user or join them to an existing game
  def create

    if params[:type] == "new"
      array = params[:date].split(' ')
      db_date = "#{array[4]}-#{Date::MONTHNAMES.index(array[3])}-#{array[1]}"

      game = Game.create!({
        date: db_date,
        start_time: params[:start_time],
        facility_id: params[:facility_id],
        sport_id: params[:sport_id]
      })
      user = User.find(current_user.id)
      game.users.push(user)
    else
      game = Game.find(params[:game_id])
      user = User.find(current_user.id)
      game.users.push(user)
    end
  end

  # Remove a user from a game or delete the game if there are no more users
  def destroy
    if user = User.find(current_user.id)
      game = Game.find(game_params[:id])

      if game.users.count > 1
        user.games.delete(game)
        else
          game.destroy
      end
      render status: 201
    else
      # handle error
    end
  end

  private

  def game_params
    params.permit(
      :id,
      :date,
      :start_time,
      :facility_id,
      :sport_id
    )
  end
end
