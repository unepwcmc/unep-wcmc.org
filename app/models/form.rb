# This model serves as a template for vacancy application forms.
# Every vacancy has a Form, editable in the admin panel, that is
# populated with TextFields and FileFields. When user applies for
# a position, a Submission with TextFieldSubmissions
# and FileFieldSubmissions is built, with the shape of a corresponding Form.

class Form < ActiveRecord::Base
  belongs_to :vacancy
  has_many :submissions, dependent: :destroy
  has_many :fields, dependent: :destroy, inverse_of: :form
  has_many :attachments, dependent: :destroy, inverse_of: :form
  accepts_nested_attributes_for :fields, allow_destroy: true
  accepts_nested_attributes_for :attachments, allow_destroy: true

  def to_csv
    csv = ''
    submission_columns = ["name", "email"]
    csv << submission_columns.join(',')
    csv << "\n"
    submissions = self.submissions.order(name: :asc)
    submissions.each do |submission|
      csv << submission.name
      csv << ","
      csv << submission.email
      csv << "\n"
    end
    csv
  end
end
