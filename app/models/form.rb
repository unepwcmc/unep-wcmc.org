class Form < ActiveRecord::Base
  belongs_to :vacancy, class_name: "Cms::Page"
  has_many :submissions, dependent: :destroy
  has_many :fields, dependent: :destroy, inverse_of: :form
  has_many :attachments, dependent: :destroy, inverse_of: :form
  accepts_nested_attributes_for :fields, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
