class User < ApplicationRecord
  # has_secure_password
  has_and_belongs_to_many :games
  has_and_belongs_to_many :sports
  has_many :timeprefs

  validates :username, presence: true, :uniqueness => {:case_sensitive => false}
  validates :email, presence: true, :uniqueness => {:case_sensitive => false}
  validates :password, presence: true, length: { minimum: 4 }

  def self.authenticate_with_credentials(username, password)
    user = User.find_by(username: username)

    if user && user.password == password
      user
    else
      nil
    end
  end
end
