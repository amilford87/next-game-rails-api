class User < ApplicationRecord
  # has_secure_password
  has_and_belongs_to_many :games
  has_and_belongs_to_many :sports
  has_many :timeprefs
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
