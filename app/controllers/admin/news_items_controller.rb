class Admin::NewsItemsController < Admin::PageResourcesController

  private

  def save_resources
    @page.save
  end

  def site_identifier
    'news'
  end

  def layout_identifier
    'news-item'
  end

end
