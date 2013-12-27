class EmploymentsBuilder

  def initialize(params)
    @project = params[:project]
    @programme = params[:programme]
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
    if @project
      Employment.destroy_for_project(@project)
    elsif @programme
      Employment.destroy_for_programme(@programme)
    end
  end

  def employments
    @employments_params.map do |employment|
      build_employment(employment)
    end
  end

  def build_employment(params)
    if @project
      return Employment.new(project_id: @project.id, employee_id: params[:id], role: params[:role])
    else
      return Employment.new(programme_id: @programme.id, employee_id: params[:id], role: params[:role])
    end
  end

end
