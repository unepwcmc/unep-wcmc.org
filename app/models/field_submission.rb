class FieldSubmission < ActiveRecord::Base
  belongs_to :field
  belongs_to :submission
  validates :field, presence: true
  validates :submission, presence: true

  def name
    field.name
  end
end
