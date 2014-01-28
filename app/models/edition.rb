class Edition < ActiveRecord::Base
  belongs_to :resource, class_name: "Cms::Page"
  belongs_to :user
end
