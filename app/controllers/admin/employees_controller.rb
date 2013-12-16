class Admin::EmployeesController < Admin::Cms::BaseController

  before_action :build_employee,  :only => [:new, :create]
  before_action :load_employee,   :only => [:show, :edit, :update, :destroy]

  def index
    @employees = Employee.page(params[:page])
  end

  def show
    render
  end

  def new
    render
  end

  def edit
    render
  end

  def create
    @employee.save!
    flash[:success] = 'Employee created'
    redirect_to :action => :show, :id => @employee
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to create Employee'
    render :action => :new
  end

  def update
    @employee.update_attributes!(employee_params)
    flash[:success] = 'Employee updated'
    redirect_to :action => :show, :id => @employee
  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = 'Failed to update Employee'
    render :action => :edit
  end

  def destroy
    @employee.destroy
    flash[:success] = 'Employee deleted'
    redirect_to :action => :index
  end

protected

  def build_employee
    @employee = Employee.new(employee_params)
  end

  def load_employee
    @employee = Employee.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = 'Employee not found'
    redirect_to :action => :index
  end

  def employee_params
    params.fetch(:employee, {}).permit(:name, :photo)
  end
end
