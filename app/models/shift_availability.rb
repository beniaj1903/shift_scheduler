class ShiftAvailability < ApplicationRecord
  has_one :shift
  has_one :employee
end
