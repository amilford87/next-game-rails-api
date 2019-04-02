class User < ApplicationRecord
  # attr_accessor :password
  # has_secure_password
  has_and_belongs_to_many :games
  def self.authenticate_with_credentials(username, password)
    # byebug
    user = User.find_by(username: username)

    if user && user.password == password
      user
    else
      nil
    end
  end
end
