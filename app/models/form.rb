# This model serves as a template for vacancy application forms.
# Every vacancy has a Form, editable in the admin panel, that is
# populated with TextFields and FileFields. When user applies for
# a position, a Submission with TextFieldSubmissions
# and FileFieldSubmissions is built, with the shape of a corresponding Form.

class Form < ActiveRecord::Base
  belongs_to :vacancy, class_name: "Cms::Page"
  has_many :submissions, dependent: :destroy
  has_many :fields, dependent: :destroy, inverse_of: :form
  has_many :attachments, dependent: :destroy, inverse_of: :form
  accepts_nested_attributes_for :fields, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
