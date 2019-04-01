class Api::UsersController < ApplicationController

  # Methods not complete
  def show
    if user = :current_user
      user.prefs = user.sports
      json_response(user)
    else
      # render json response error here
    end
  end

  def update
    # take userinfo change json and update db
  end

  def destroy
    # destroy user from db and all refs in join tables
  end

  private

end
