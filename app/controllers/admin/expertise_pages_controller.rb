class Admin::ExpertisePagesController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'expertise'
  end

  def layout_identifier
    'expertise'
  end

end
