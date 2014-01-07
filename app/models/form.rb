class Form < ActiveRecord::Base
  belongs_to :vacancy, class_name: "Cms::Page"
  has_many :submissions, dependent: :destroy
  has_many :fields, dependent: :destroy
end
