class Admin::VacanciesController < Admin::PageResourcesController
  before_action :set_form, only: [:edit, :update]
  before_action :build_form, only: [:create]
  before_action :set_vacancy_fields, only: [:edit, :create]

  private

  def save_resources
    if @page.save
      @form.update(form_params.merge(vacancy_id: @page.id))
      vacancy_fields.save
    else
      false
    end
  end

  def site_identifier
    'vacancies'
  end

  def layout_identifier
    'vacancy'
  end

  def set_form
    @form = Form.where(vacancy_id: @page.id).first
  end

  def build_form
    @form = Form.new(vacancy_id: @page.id)
  end

  def form_params
    params[:form].try(:permit, fields_attributes: [:_destroy, :name, :id, :type], attachments_attributes: [:_destroy, :name, :id, :file]) || {}
  end

  def set_vacancy_fields
    @vacancy_fields ||= VacancyField.for_vacancy(@page)
  end

  def vacancy_fields_params
    params[:vacancyFieldForms].try(:values) || []
  end

  def vacancy_fields
    VacancyFieldsBuilder.new(fields_params: vacancy_fields_params,
      vacancy: @page)
  end
end
