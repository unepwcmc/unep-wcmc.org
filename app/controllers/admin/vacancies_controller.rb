class Admin::VacanciesController < Admin::PageResourcesController
  before_action :set_form, only: :edit
  before_action :build_form, only: :new

  private

  def save_resources
    @page.save
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
    @form = Form.new
  end

end
