class Api::GamesController < ApplicationController

  # Methods not complete
  def index
    if @user = User.first
      @current_games = @user.games
      @user_current_games_data = []
      @user.games.each do |game|
        @game_sport = Sport.find(game.sport_id).name
        @game_facility_name = Facility.find(game.facility_id).name
        @game_facility_lat = Facility.find(game.facility_id).latitude
        @game_facility_lng = Facility.find(game.facility_id).longitude
        @game_other_players = []
        game.user_ids.each do |user|
          @my_games_usernames = User.find(user).username
          @game_other_players.push(@my_games_usernames)
        end
        @users_saved_games = { other_players: @game_other_players.count,
                        date: game.date.strftime("%A %d of %B %Y"),
                        time: game.start_time.strftime("%I:%M %p"),
                        sport: @game_sport,
                        location: @game_facility_name,
                        map: {lat: @game_facility_lat.to_f, lng: @game_facility_lng.to_f}
                       }
      @user_current_games_data.push(@users_saved_games) 
      end
      render json: @user_current_games_data, status: 200
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  def post
    if user = :current_user
      user.create(game_params)
      json_response()
    else
      # handle error
    end
  end

  def destroy
    if user = :current_user
      game = Game.find(game_params[:id])
      # does this work?
      user.game.destroy
      json_response()
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
