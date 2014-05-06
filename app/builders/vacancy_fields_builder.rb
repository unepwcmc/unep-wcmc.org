class VacancyFieldsBuilder
  def initialize(params)
    @fields_params = params[:fields_params]
    @vacancy_id = params[:vacancy].id
  end

  def save
    @fields_params.each do |params|
      params = params.merge(vacancy_id: @vacancy_id)
      if !params[:custom_label].empty?
        params[:label] = params[:custom_label]
      end
      if params[:id]
        update_field(params)
      else
        create_field(params)
      end
    end
  end

  private

  def create_field(params)
    params.delete(:custom_label)
    VacancyField.create(params)
  end

  def update_field(params)
    if params[:removed]
      VacancyField.find(params[:id]).destroy
    else
      unless params[:file]
        params.delete(:file)
      end
      params.delete(:custom_label)
      VacancyField.find(params[:id]).update(params)
    end
  end

end
