class ProjectEmploymentsBuilder

  def initialize(params)
    @project = params[:project]
    @employments_params = params[:employments]
  end

  def save
    ActiveRecord::Base.transaction do
      destroy_employments
      employments.each do |employment|
        employment.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def destroy_employments
    Employment.destroy_for_project(@project)
  end

  def employments
    @employments_params.map do |employment|
      build_employment(employment)
    end
  end

  def build_employment(params)
    Employment.new(project_id: @project.id, employee_id: params[:id], role: params[:role])
  end

end
