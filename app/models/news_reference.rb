class NewsReference < ActiveRecord::Base 
  belongs_to :news, class_name: "Cms::Page"
  belongs_to :related_news, class_name: "Cms::Page"

end
