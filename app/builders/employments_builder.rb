class EmploymentsBuilder

  def initialize(project, params)
    @project = project
    @employments = params.map do |employment|
      Employment.new(project_id: project.id, employee_id: employment[:id], role: employment[:role])
    end
  end

  def save
    begin
      ActiveRecord::Base.transaction do
        Employment.where(project_id: @project.id).destroy_all
        unless @employments.all? { |employment| employment.save }
          raise ActiveRecord::RecordInvalid
        end
      end
    rescue ActiveRecord::RecordInvalid
      return false
    end
    true
  end
end
