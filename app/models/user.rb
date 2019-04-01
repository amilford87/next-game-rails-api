require 'bcrypt'

class User < ApplicationRecord
  include  BCrypt

  has_secure_password
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :games

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
#   validates :password, presence: true, length: { minimum: 4 }
#   validates :password_confirmation, presence: true
end
