module NewsHelper

  def related_news(current_news_id)
    news_references = NewsReference.where('news_id' => current_news_id)
    @related_news = Cms::Site.find_by_identifier('news').pages.root.children.published.where('id' => [news_references[0].related_news_id,  news_references[1].related_news_id])
  end

end
