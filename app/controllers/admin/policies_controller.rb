class Admin::PoliciesController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'policies'
  end

  def layout_identifier
    'policy'
  end
end
