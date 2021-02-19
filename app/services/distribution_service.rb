module DistributionService
    def self.distribute params
      distribuited_shifts = []
      ordered_shifts = Shift
        .where(id: params[:shift_ids].map{|id| id.to_i})
        .joins("LEFT JOIN weeks ON weeks.id = shifts.week_id")
        .select("shifts.*", "weeks.year as w_year", "weeks.number as w_number")
        .order(:w_year,:w_number,:day)
        .map(&:id)
      shift_availabilities = ShiftAvailability
        .where(employee_id: params[:employee_ids].map{|id| id.to_i}, shift_id: ordered_shifts)
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
          unless availabilities.blank?
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
                  su = shift.update(employee_id: availabilities.find { |id| id == fewer_id.to_i })
                  count_employees_hash[fewer_id] += 1
              else
                  su = shift.update(employee_id: availabilities[employee_index])
                  count_employees_hash[availabilities[employee_index].to_s] += 1
              end
              if su
                distribuited_shifts << shift
              end
          end
        end
        distribuited_shifts
    end
end