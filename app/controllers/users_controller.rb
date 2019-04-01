class UsersController < ApplicationController

  # Methods not complete
  def create
    # byebug
    user = User.new(user_params)

    puts "here: #{user}"
    if user.save
      session[:user_id] = user.id
      render :json => user
    else
      # render json response error here
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :image,
      :username,
      :email,
      :password,
      :password_confirmation
    )
  end
end

# These are the params: {"state"=>{"avatar"=>"None", "username"=>"Matt", "email"=>"faker@email.net", "password"=>"123", "passwordConfirmation"=>"123", "distance"=>20, "sports"=>["soccer"], "startDate"=>"2019-04-01T15:40:31.093Z", "endDate"=>"2019-04-01T15:40:31.093Z", "currentLocation"=>{"lat"=>43.6500371, "lng"=>-79.3918359}, "loadedLocation"=>true}, "controller"=>"users", "action"=>"create", "user"=>{}}

