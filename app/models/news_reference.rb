class NewsReference < ActiveRecord::Base 
  belongs_to :news_item, class_name: "Cms::Page"

end
