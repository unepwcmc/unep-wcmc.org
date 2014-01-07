class Submission < ActiveRecord::Base
  belongs_to :form
  has_many :field_submissions, dependent: :destroy, inverse_of: :submission
  accepts_nested_attributes_for :field_submissions

  validates :form, presence: true

  def self.build_for_form(form)
    submission = new(form_id: form.id)
    form.fields.each do |field|
      submission.field_submissions.build(type: field.type + "Submission", field_id: field.id)
    end
    submission
  end

end
