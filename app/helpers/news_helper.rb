module NewsHelper

  def related_news(current_news_id)
    news_references = NewsReference.where(news_id: current_news_id)
    @related_news = Cms::Page.published.where("id IN (?)", news_references.map(&:related_news_id))
  end

end
