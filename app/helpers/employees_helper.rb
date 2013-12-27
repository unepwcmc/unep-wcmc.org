module EmployeesHelper
  def employment
    @employment ||= Employment.for_programmes.includes(:programme).for_employee(@cms_page).first
  end

  def project_employments
    @project_employments ||= Employment.for_projects.includes(:project).order("created_at DESC").for_employee(@cms_page).take(3)
  end
end
