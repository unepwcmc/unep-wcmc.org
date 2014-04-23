class Programme < ActiveRecord::Base
  has_many :employments, dependent: :destroy
  has_many :employees, through: :employments, class_name: "Cms::Page"
  has_many :subprogrammes, foreign_key: "parent_programme_id", class_name: "Programme"
  accepts_nested_attributes_for :subprogrammes
end
