class Timepref < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates :week_day, presence: true, inclusion: { in: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'] }
end
