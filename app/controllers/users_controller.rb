class UsersController < ApplicationController

  # Methods not complete
  def create
    user = User.new(user_params)

    #Bad bad not checking password confirmation!
    # if user_params[:password] == user_params[:password_confirmation]
    # end

    if user.save
      session[:user_id] = user.id

      # Add user sport preferences
      params[:sports].each do |as|
        sport_pointer = Sport.find_by(name: as)
        sport_pointer.users << user
      end

      # Make timeprefs table entries for the new user
      week_days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
      week_days.each do |wd|
        user.timeprefs.create!({
            week_day: wd,
            active: false
        })
      end

      render :json => user, status: 201
    else
      render json: { message: 'Could not save user' }, status: 409
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

