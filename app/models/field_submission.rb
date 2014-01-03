class FieldSubmission < ActiveRecord::Base
  belongs_to :field
  belongs_to :form_submission
end
