class SessionsController < ApplicationController

  # Methods not complete
  def create
    if @user = User.authenticate_with_credentials(session_params[:username], session_params[:password])
      session[:user_id] = @user.id
      render json: @user, status: 200
    else
      render json: { message: 'incorrect credentials' }, status: 401
    end
  end

  def destroy
    session[:user_id] = nil
    # end user session on front end somehow?
  end

  private

  def session_params
    params.require(:session).permit(
      :username,
      :password,
    )
  end
end
