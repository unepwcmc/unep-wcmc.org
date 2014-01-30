class Admin::NewsItemsController < Admin::PageResourcesController

  before_action :set_news_list, :only => [:edit, :new, :create, :update]
  before_action :set_references, :only => [:edit, :new, :create, :update]

  private

  def save_resources
    if @page.save
      NewsReference.where(news_id: @page.id).destroy_all
      related_news_ids.each do |id|
        NewsReference.create(news_id: @page.id, related_news_id: id)
      end
      true
    end
  end

  def site_identifier
    'news'
  end

  def layout_identifier
    'news-item'
  end

  def set_news_list
    @news_list = Cms::Site.find_by_identifier('news').pages.root.children.published
  end

  def set_references
    @references = NewsReference.where(news_id: @page.id)
  end

  def related_news_ids
    [params[:news_item]['0'][:id], params[:news_item]['1'][:id]]
  end
end
