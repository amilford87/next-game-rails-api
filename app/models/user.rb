class User < ApplicationRecord
  # attr_accessor :password
  has_secure_password

  def self.authenticate_with_credentials(username, password)
    byebug
    user = User.find_by(username: username)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end
end
