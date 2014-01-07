class FieldSubmission < ActiveRecord::Base
  default_scope -> { order("created_at ASC") }
  belongs_to :field
  belongs_to :submission
  validates :field, presence: true
  validates :submission, presence: true

  def name
    field.name
  end
end
