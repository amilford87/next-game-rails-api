class SessionsController < ApplicationController

  # Methods not complete
  def create
    if user = User.authenticate_with_credentials(session_params[:username], session_params[:password])
      session[:user_id] = user.id
      json_response(user)
    else
      # render json response error here
    end
  end

  def destroy
    session[:user_id] = nil
    # end user session on front end somehow?
  end

  private

  def session_params
    params.permit(
      :username,
      :password,
    )
  end
end
