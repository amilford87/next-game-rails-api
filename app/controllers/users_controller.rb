class UsersController < ApplicationController

  # Methods not complete
  def create
    user = User.new(user_params)
    if user_params[:password] == user_params[:password_confirmation]

    end
    if user.save
      session[:user_id] = user.id

      # Add user sport preferences
      params[:sports].each do |as|
        sport_pointer = Sport.find_by(name: as)
        sport_pointer.users << user
      end
      render :json => user, status: 200
    else
      render json: { message: 'Could not save user' }, status: 409
      # render json response error here
    end
  end

  def show
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

