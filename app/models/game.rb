class Game < ApplicationRecord
  belongs_to :facility
  belongs_to :sport
  has_many :users

  validates :date, presence: true
  validates :start_time, presence: true
  validates :facility_id, presence: true
  validates :sport_id, presence: true
end
