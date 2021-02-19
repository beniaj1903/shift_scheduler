require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe 'attributes' do
    let!(:employee) { Employee.create(name: "Juan") }
    let!(:service) { Service.create(name: "Move SPA") }
    let!(:weeks) { [Week.create(number: 02, year: 2021), Week.create(number: 03, year: 2021), Week.create(number: 04, year: 2021)] }
    let!(:shifts) { [
      Shift.create(employee_id: employee.id, service_id: service.id, week_id: weeks[0].id, start_time: Time.now, end_time: (Time.now + 1.hour), day: 1),
      Shift.create(employee_id: employee.id, service_id: service.id, week_id: weeks[1].id, start_time: (Time.now + 1.week), end_time: (Time.now + 1.hour), day: 1),
      Shift.create(employee_id: employee.id, service_id: service.id, week_id: weeks[2].id, start_time: (Time.now + 2), end_time: (Time.now + 1.hour), day: 1)
    ] }
    it 'uses match array to match a scope' do
      expect(Shift.all).to match_array(shifts)
    end
  end
  context 'before creation' do
    let!(:no_service_id_shift) { Shift.create(service_id: nil) }
    let!(:no_week_id_shift) { Shift.create(week_id: nil) }
    let!(:no_start_time_shift) { Shift.create(start_time: nil) }
    let!(:no_end_time_shift) { Shift.create(end_time: nil) }
    let!(:no_day_shift) { Shift.create(day: nil) }
    let!(:employees) { [Employee.create(name: "Juan"), Employee.create(name: "Pedro")] }
    let!(:services) { [Service.create(name: "Move SPA"), Service.create(name: "Move 2 SPA")] }
    let!(:week) { Week.create(number: 02, year: 2021) }
    let!(:shift) { 
      Shift.create(service_id: services[0].id, employee_id: employees[0].id, week_id: week.id, start_time: Time.now.beginning_of_hour, end_time: (Time.now.beginning_of_hour + 1.hour), day: 1)
    }
    it 'cannot have an employee with two shifts at the same time' do
      expect { 
        Shift.create(service_id: services[1].id, employee_id: employees[0].id, week_id: week.id, start_time: Time.now.beginning_of_hour, end_time: (Time.now.beginning_of_hour + 1.hour), day: 1) 
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'cannot have a service with two shifts at the same time' do
      expect { 
        Shift.create(employee_id: employees[1].id, service_id: services[0].id, week_id: week.id, start_time: Time.now.beginning_of_hour, end_time: (Time.now.beginning_of_hour + 1.hour), day: 1) 
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'musta have an service_id' do
      expect(no_service_id_shift.errors.errors).not_to be_empty
    end
    it 'musta have an week_id' do
      expect(no_week_id_shift.errors.errors).not_to be_empty
    end
    it 'musta have an start_time' do
      expect(no_start_time_shift.errors.errors).not_to be_empty
    end
    it 'musta have an end_time' do
      expect(no_end_time_shift.errors.errors).not_to be_empty
    end
    it 'musta have an day' do
      expect(no_day_shift.errors.errors).not_to be_empty
    end
  end
end
