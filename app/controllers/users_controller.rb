class UsersController < ApplicationController

  # Methods not complete
  def create
    user = User.new(user_params)
    if user_params[:password] == user_params[:password_confirmation]

    end
    if user.save
      session[:user_id] = user.id
      puts "SAVED SETTING SESSION"
      render :json => user, status: 200
    else
      puts "NOT SAVED"
      # render json response error here
    end
    puts "Session #{session}"
  end

  def show
    puts "session id #{session[:user_id]}"
    render :json => {id: session[:user_id]}
  end

  private

  def user_params
    params.require(:user).permit(
      :image,
      :username,
      :email,
      :password,
      # :password_confirmation
    )
  end
end

