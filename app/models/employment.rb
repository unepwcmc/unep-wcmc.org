class Employment < ActiveRecord::Base
  belongs_to :project, class_name: "Cms::Page"
  belongs_to :employee, class_name: "Cms::Page"

  def self.with_employees_for_project(project)
    includes(:employee).for_project(project)
  end

  def self.for_project(project)
    where(project_id: project.id)
  end

  def self.for_employee(employee)
    where(employee_id: employee.id)
  end

  def self.destroy_for_project(project)
    for_project(project).destroy_all
  end

  def self.destroy_for_employee(employee)
    for_employee(employee).destroy_all
  end
end
