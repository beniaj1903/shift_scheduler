class Employee < ApplicationRecord
  has_many :shifts
  has_many :shift_availabilities
  validates :name, presence: true
end
