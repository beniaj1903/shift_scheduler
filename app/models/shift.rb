class Shift < ApplicationRecord
    has_one :service
    has_one :employee
    has_one :week
    has_many :shift_availabilities
    validates :service_id, :week_id, :start_time, :end_time, :day, presence: true
end
