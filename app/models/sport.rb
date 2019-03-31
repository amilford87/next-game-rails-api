class Sport < ApplicationRecord
  has_many_and_belongs_to_many :users
  has_many_and_belongs_to_many :facilities
  has_many :games

  validate :name, presence: true
end
