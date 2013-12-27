class Programme < ActiveRecord::Base
  has_many :employments, dependent: :destroy
  has_many :employees, through: :employments, class_name: "Cms::Page"
end
