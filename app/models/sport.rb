class Sport < ApplicationRecord
  has_many :users
  has_many :facilities
  has_many :games

  validate :name, presence: true
end
