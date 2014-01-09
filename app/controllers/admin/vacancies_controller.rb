class Admin:VacanciesController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'vacancies'
  end

  def layout_identifier
    'vacancies'
  end

end
