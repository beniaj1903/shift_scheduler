class Api::V1::ShiftsController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token

  def index
    weeks = Week.all
    employees = Employee.all
    services = Service.all
    service_id = if params[:service_id].blank?
                   Service.first
                 else
                   params[:service_id].to_i
                 end
    week_id = if params[:week_id].blank?
                Week.first
              else
                params[:week_id].to_i
              end
    shifts = Shift.where(service_id: service_id, week_id: week_id)
    shift_availabilities = ShiftAvailability.where(shift_id: shifts.map(&:id))

    response = {
      json: {
        shifts: ApiHelper.api_response_normalization(shifts),
        weeks: ApiHelper.api_response_normalization(weeks),
        employees: ApiHelper.api_response_normalization(employees),
        services: ApiHelper.api_response_normalization(services),
        shift_availabilities: ApiHelper.api_response_normalization(shift_availabilities)
      }, status: 200
    }
    render response
  end

  def create
    shifts_to_create = []
    response = { json: { error: 'No se pudieron crear turnos', status: 400 } }
    if !params[:shifts].select { |shift| !shift.blank? }.blank?
      params[:shifts].each do |shift|
        shifts_to_create << Shift.new(shift_params(shift))
      end
    else
      response = { json: { message: 'empty params', status: 200 } }
    end
    unless shifts_to_create.blank?
      shifts_to_create.each { |shift| shift.save }
      response = {
        json: {
          shifts: ApiHelper.api_response_normalization(shifts_to_create)
        }, status: 201
      }
    end
    render response
  end

  def availabilities
    # sa: shift_availability
    # sas: shift_availabilities
    sas_to_create = []
    response = { json: { error: 'No se pudieron crear turnos', status: 400 } }
    if !params[:sas].reject(&:blank?).blank?
      params[:sas].each do |sa|
        sas_to_create << ShiftAvailability.find_or_create_by(shift_availabilities_params(sa))
      end
    else
      response = { json: { message: 'empty params', status: 200 } }
    end
    if !params[:sas_to_destroy].blank?
      sas_to_destroy = ShiftAvailability.where(
        employee_id: params[:sas_to_destroy].map(&:employee_id), 
        shift_id: params[:sas_to_destroy].map(&:shift_id)
        )
      sas_to_destroy.destroy_all
    end
    unless sas_to_create.blank?
      response = {
        json: {
          shift_availabilities: ApiHelper.api_response_normalization(sas_to_create)
        }, status: 201
      }
    end
    render response
  end

  def distribute
    response = { json: { error: 'No se pudieron distribuir los turnos' }, status: 400 }
    distribuited_shifts = DistributionService.distribute(params)
    unless distribuited_shifts.blank?
      shifts = Shift.where(service_id: distribuited_shifts[0].service_id, week_id: distribuited_shifts[0].week_id)
      response = {
        json: {
          shifts: ApiHelper.api_response_normalization(shifts)
        }, status: 200
      }
    end
    render response
  end

  private

  def shift_params(shift)
    shift.permit(:service_id, :week_id, :day, :start_time, :end_time)
  end

  def shift_availabilities_params(shift_availability)
    shift_availability.permit(:employee_id, :shift_id)
  end
end
