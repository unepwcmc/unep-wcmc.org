# Relation between an employee (represented as CMS page)
# and a project or programme.

class Employment < ActiveRecord::Base
  belongs_to :project, class_name: "Comfy::Cms::Page"
  belongs_to :employee, class_name: "Comfy::Cms::Page"
  belongs_to :programme

  def self.with_employees_for_project(project)
    includes(:employee).for_project(project)
  end

  def self.for_project(project)
    where(project_id: project.id)
  end

  def self.for_employee(employee)
    where(employee_id: employee.id)
  end

  def self.for_programmes
    where("programme_id IS NOT NULL")
  end

  def self.for_projects
    where("project_id IS NOT NULL")
  end

  def self.destroy_for_project(project)
    for_project(project).destroy_all
  end

  def self.destroy_for_employee(employee)
    for_employee(employee).destroy_all
  end

  def self.destroy_for_programme(programme)
    where(programme_id: programme.id).destroy_all
  end

  def self.destroy_programmes_for_employee(employee)
    self.for_programmes.for_employee(employee).destroy_all
  end
end
