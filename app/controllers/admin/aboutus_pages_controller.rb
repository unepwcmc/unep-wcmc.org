class Admin::AboutusPagesController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'about-us'
  end

  def layout_identifier
    'about-us'
  end

end
