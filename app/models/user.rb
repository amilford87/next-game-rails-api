class User < ApplicationRecord
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :games

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8 }
  validates :password_confirmation, presence: true
end
