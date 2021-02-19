require 'rails_helper'

RSpec.describe 'Shifts', type: :request do
  describe 'create' do
    let!(:service) { Service.create(name: 'Move SPA') }
    let!(:week) { Week.create(number: 0o2, year: 2021) }
    it 'creates a service week shifts' do
      mock = double('Shift', shifts: [
                      { service_id: 1, week_id: 1, day: 1, start_time: Time.now.beginning_of_hour,
                        end_time: (Time.now.beginning_of_hour + 1) },
                      { service_id: 1, week_id: 1, day: 2, start_time: Time.now.beginning_of_hour,
                        end_time: (Time.now.beginning_of_hour + 1) },
                      { service_id: 1, week_id: 1, day: 3, start_time: Time.now.beginning_of_hour,
                        end_time: (Time.now.beginning_of_hour + 1) }
                    ])
      headers = { 'ACCEPT' => 'application/json' }
      post '/api/v1/shifts', params: { shifts: mock.shifts }, headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['shifts'].count).to eq(mock.shifts.count)
    end
    it 'tries to create with an empty array' do
      headers = { 'ACCEPT' => 'application/json' }
      post '/api/v1/shifts', params: { shifts: [] }, headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('empty params')
    end
  end
  describe 'simple distribute verifications' do
    let!(:employees) { [Employee.create(name: 'Juan'), Employee.create(name: 'Diego')] }
    let!(:service) { Service.create(name: 'Move SPA') }
    let!(:weeks) do
      [Week.create(number: 0o2, year: 2021), Week.create(number: 0o3, year: 2021),
       Week.create(number: 0o4, year: 2021)]
    end
    let!(:shifts) do
      [
        Shift.create(service_id: service.id, week_id: weeks[0].id, start_time: Time.now,
                     end_time: (Time.now + 1.hour), day: 1),
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
    it 'verificates all sended shifts are distributed' do
      headers = { 'ACCEPT' => 'application/json' }
      post '/api/v1/shifts/distribute',
           params: { shift_ids: shifts.map(&:id), employee_ids: employees.map(&:id) }, headers: headers
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['shifts'].count).to eq(shifts.count)
    end
  end
  describe 'complex distribute verifications' do
    let!(:shifts) { ShiftsHelper.large_arrays }
    # let!(:shift_availabilities) do
    #     ShiftsHelper.large_arrays()
    # end
    it 'verificates diferences between employees shifts distribution are <= 1, when the availabilities are similar' do
      headers = { 'ACCEPT' => 'application/json' }
      post '/api/v1/shifts/distribute',
           params: { shift_ids: shifts[:large_shift_array].map(&:id), employee_ids: shifts[:employees].map(&:id) }, headers: headers

      # maps in a hash the shift count for each employee
      employees_count_hash = shifts[:employees].each_with_object({}) do |employee, obj|
        obj[employee.id.to_s] = 0
      end
      JSON.parse(response.body)['shifts'].each do |shift|
        employee_id = shift[1]['employee_id']
        employees_count_hash[employee_id.to_s] += 1 unless employee_id.blank?
      end
      # find the min and max value
      minmax = employees_count_hash.values.minmax
      sas = ShiftAvailability.where(id: shifts[:large_shift_availabilities].map(&:id))
                             .select('COUNT(*) as availabilities_count', 'employee_id')
                             .group(:employee_id)
                             .order(:availabilities_count)
                             .map(&:availabilities_count)
      sa_minmax = sas.minmax
      # tolerance = 1
      tolerance = sa_minmax[1] - sa_minmax[0]
      p tolerance
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:ok)

      # The max difference that the week distribution can have is tolerance,
      # so the expect checks that the distribution satisfy this
      expect(minmax[1] - minmax[0]).to be <= tolerance
    end
  end
end
