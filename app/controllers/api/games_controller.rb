class Api::GamesController < ApplicationController

  # Methods not complete
  def index
    if @user = User.first
      @current_games = @user.games
      testing = @current_games.each do |game|
        game.id 
      end 

      render json: testing, status: 200
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
