class Admin::VacanciesController < Admin::PageResourcesController
  before_action :set_form, only: [:edit, :update]
  before_action :build_form, only: [:create]

  private

  def save_resources
    saved = @page.save
    if saved
      @form.update(form_params.merge(vacancy_id: @page.id))
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
    params[:form].try(:permit, fields_attributes: [:_destroy, :name, :id, :type]) || {}
  end

end
