class Employment < ActiveRecord::Base
  belongs_to :project, class_name: "Cms::Page"
  belongs_to :employee, class_name: "Cms::Page"

  def self.with_employees_for_project(project)
    includes(:employee).where(project_id: project.id)
  end
end
