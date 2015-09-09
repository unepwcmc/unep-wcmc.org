class Admin::NewsItemsController < Admin::PageResourcesController

  before_action :set_news_list, :only => [:edit, :new, :create, :update]

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

  def set_news_list
    @news_list = Comfy::Cms::Site.find_by_identifier('news').pages.root.children.published
  end

end
