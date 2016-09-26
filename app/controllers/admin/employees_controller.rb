class Admin::EmployeesController < Admin::PageResourcesController
  before_action :set_programmes,   :only => [:edit, :new, :create, :update]
  before_action :set_employment,   :only => [:edit, :new, :create, :update]

  private

  def save_resources
    @page.save && employment.save
  end

  def layout_identifier
    'employee'
  end

  def site_identifier
    'employees'
  end

  def set_programmes
    @programmes = Programme.all
  end

  def set_employment
    @employment = Employment.for_programmes.for_employee(@page).first
  end

  def employment
    ProgrammeEmploymentBuilder.new(employment: employment_params, employee: @page)
  end

  def employment_params
    params.require(:programme).permit(:id, :role)
  end
end
