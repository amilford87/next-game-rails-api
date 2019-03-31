class Facility < ApplicationRecord
  has_and_belongs_to_many :sports
  has_many_ :games

  validates :name, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
