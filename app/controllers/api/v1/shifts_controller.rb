class Api::V1::ShiftsController < Api::V1::ApiController
    def index
        
        shifts = Shift.all
        weeks = Week.all
        employees = Employee.all
        services = Service.all
        shift_availabilities = ShiftAvailability.all
        
        response = {
            json: {
                shifts: ApiHelper.api_response_normalization(shifts),
                weeks: ApiHelper.api_response_normalization(weeks),
                employees: ApiHelper.api_response_normalization(employees),
                services: ApiHelper.api_response_normalization(services),
                shift_availabilities: ApiHelper.api_response_normalization(shift_availabilities),
            }, status: 200
        }
        render response
    end

    def create
        shifts_to_create = []
        response = { json: { error: "No se pudieron crear turnos", status: 400 } }
        if !params[:shifts].select{ |shift| !shift.blank? }.blank?
            params[:shifts].each do |shift|
                shifts_to_create << Shift.new(shift_params(shift))
            end
        else
            response = { json: { message: "empty params", status: 200 } }
        end
        if !shifts_to_create.blank?
            shifts_to_create.each { |shift| shift.save } 
            response = {
                json: {
                    shifts: ApiHelper.api_response_normalization(shifts_to_create),
                }, status: 201
            }
        end
        render response
    end

    def distribute
        response = { json: { error: "No se pudieron distribuir los turnos" }, status: 400 }
        distribuited_shifts = []
        shift_availabilities = ShiftAvailability.where(employee_id: params[:employee_ids].map{ |id| id.to_i }, shift_id: params[:shift_ids].map{ |id| id.to_i })
        .select("COUNT(*) as availabilities_count", "employee_id", "group_concat(CAST(shift_availabilities.shift_id AS varchar), '-') as shift_ids")
        .group(:employee_id)
        .order(:availabilities_count)
        shifts = Shift.where(id: shift_availabilities.map(&:shift_ids).inject([]){|array, ids| array += ids.split('-').map{|id| id.to_i}}.uniq)
        shifts.update(employee_id: nil)
        max_shifts_by_employee = (shifts.count / params[:employee_ids].count).truncate
        count_employees_hash = params[:employee_ids].inject({}) do |obj, employee_id| 
            obj[employee_id.to_s] = 0
            obj
        end
        employee_index = 0
        shifts.each do |shift|
            availabilities = shift_availabilities.select{ |sa| sa.shift_ids.split('-').include?(shift.id.to_s) }.map(&:employee_id)
            if !availabilities.blank?
                if availabilities[employee_index] && count_employees_hash[availabilities[employee_index].to_s] >= max_shifts_by_employee
                    employee_index += 1
                end
                if availabilities[employee_index].blank?
                    # fewer_id = employee_id with fewer counts of shifts
                    fewer_id = availabilities[0].to_s
                    # get the correct fewer_id
                    count_employees_hash.each do |employee_id, count|
                        if availabilities.find { |id| id == employee_id.to_i } && count_employees_hash[fewer_id] > count
                            fewer_id = employee_id
                        end
                    end
                    shift.update(employee_id: availabilities.find { |id| id == fewer_id.to_i })
                    count_employees_hash[fewer_id] += 1
                else
                    shift.update(employee_id: availabilities[employee_index])
                    count_employees_hash[availabilities[employee_index].to_s] += 1
                end
                distribuited_shifts << shift
            end
        end
        p "distribuited_shifts.map(&:employee_id)"
        p distribuited_shifts.map(&:employee_id)
        p "distribuited_shifts.map(&:employee_id)"
        response = {
            json: {
                shifts: ApiHelper.api_response_normalization(distribuited_shifts),
            }, status: 200
        }
        render response
    end

    private 
    def shift_params shift
        shift.permit(:service_id, :week_id, :day, :start_time, :end_time)
    end
end
