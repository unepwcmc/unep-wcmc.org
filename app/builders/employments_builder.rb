class EmploymentsBuilder

  def initialize(project, params)
    @project = project
    @params = params
  end

  def save
    build_employments
    begin
      ActiveRecord::Base.transaction do
        Employment.destroy_for_project(@project)
        unless @employments.all? { |employment| employment.save }
          raise ActiveRecord::RecordInvalid
        end
      end
    rescue ActiveRecord::RecordInvalid
      return false
    end
    true
  end

  def build_employments
    @employments = @params.map do |employment|
      Employment.new(project_id: @project.id, employee_id: employment[:id], role: employment[:role])
    end
  end
end
