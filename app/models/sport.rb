class Sport < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :facilities
  has_many :games

  validates :name, presence: true
end
