class Api::GamesController < ApplicationController

  # Methods not complete
  def index
    if user = :current_user
      current_games = user.games
      json_response(current_games)
    else
      # handle error
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
