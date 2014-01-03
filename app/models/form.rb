class Form < ActiveRecord::Base
  belongs_to :vacancy, class_name: "Cms::Page"
  has_many :submissions
  has_many :fields
end
