class ProgrammeEmploymentBuilder
  def initialize(params)
    @employment_params = params[:employment]
    @employee = params[:employee]
  end

  def save
    ActiveRecord::Base.transaction do
      Employment.destroy_programmes_for_employee(@employee)
      employment.save!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def employment
    Employment.new(programme_id: @employment_params[:id], role: @employment_params[:role], employee_id: @employee.id)
  end

end
