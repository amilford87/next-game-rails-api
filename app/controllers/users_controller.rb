class UsersController < ApplicationController

  # Methods not complete
  def create
    puts "These are the params: #{params}"
    render :json => { :username => params[:username], :status => "ok" }
    # json_response()
    # user = User.new(user_params)
    # if user.save
    #   session[:user_id] = user.id
    #   json_response(user)
    # else
    #   # render json response error here
    # end
  end

  private

  def user_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :image
    )
  end
end
