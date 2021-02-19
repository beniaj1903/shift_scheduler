require 'rails_helper'

RSpec.describe ShiftAvailability, type: :model do
  describe 'attributes' do
    let!(:employees) { [Employee.create(name: 'Juan'), Employee.create(name: 'Diego')] }
    let!(:service) { Service.create(name: 'Move SPA') }
    let!(:weeks) do
      [Week.create(number: 0o2, year: 2021), Week.create(number: 0o3, year: 2021), Week.create(number: 0o4, year: 2021)]
    end
    let!(:shifts) do
      [
        Shift.create(service_id: service.id, week_id: weeks[0].id, start_time: Time.now, end_time: (Time.now + 1.hour),
                     day: 1),
        Shift.create(service_id: service.id, week_id: weeks[1].id, start_time: (Time.now + 1.week),
                     end_time: (Time.now + 1.hour), day: 1),
        Shift.create(service_id: service.id, week_id: weeks[2].id, start_time: (Time.now + 2),
                     end_time: (Time.now + 1.hour), day: 1)
      ]
    end
    let!(:shift_availabilities) do
      [
        ShiftAvailability.create(employee_id: employees[0].id, shift_id: shifts[0].id),
        ShiftAvailability.create(employee_id: employees[1].id, shift_id: shifts[0].id),
        ShiftAvailability.create(employee_id: employees[0].id, shift_id: shifts[1].id),
        ShiftAvailability.create(employee_id: employees[0].id, shift_id: shifts[2].id),
        ShiftAvailability.create(employee_id: employees[1].id, shift_id: shifts[2].id)
      ]
    end
    it 'uses match array to match a scope' do
      expect(ShiftAvailability.all).to match_array(shift_availabilities)
    end
  end
end
