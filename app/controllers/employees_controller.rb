require 'net/http'
require 'json'
class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_employee_api_service, only: %i[index show create update edit]

  def index
    @employees = @employee_api_service.index(params[:page])
  end  

  def edit
    @employee = @employee_api_service.show(params[:id])
  end

  def show
    @employee = @employee_api_service.show(params[:id])
  end

  def create
    response = @employee_api_service.create(employee_params)
    handle_response(response, success_flash: 'Employee created successfully')
  end
  
  def update
    response = @employee_api_service.update(params[:id], employee_params)
    handle_response(response, success_flash: 'Employee updated successfully')
  end 

  private

  def set_employee_api_service
    @employee_api_service ||= EmployeeApiService.new
  end

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end

  def handle_response(response, success_flash:)
    if response[:code].to_i / 100 == 2
      flash[:success] = success_flash
      redirect_to action: :index
    else
      flash[:error] = "API Error: Response Code - #{response[:code]}, Response Body - #{response[:body]}"
      redirect_back fallback_location: root_path
    end
  end
end
