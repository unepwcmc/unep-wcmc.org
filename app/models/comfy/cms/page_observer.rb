class Comfy::Cms::PageObserver < ActiveRecord::Observer
  def before_destroy(page)
    destroy_employments_for(page)
  end

  def after_destroy(page)
    destroy_forms_for(page)
  end

  private

  def destroy_employments_for(page)
    if employee?(page)
      Employment.destroy_for_employee(page)
    elsif featured_project?(page)
      Employment.destroy_for_project(page)
    end
  end

  def employee?(page)
    page.site.identifier == 'employees'
  end

  def featured_project?(page)
    page.site.identifier == 'featured-projects'
  end

  def destroy_forms_for(page)
    Form.where(vacancy_id: page.id).destroy_all
  end
end
