class Submission < ActiveRecord::Base

  ALLOWED_CONTENT_FIELDS = [:uk_working_ability, :last_salary, :benefits, :interview_availability, :notice_period, :reference, :reference_details]

  REFERENCE_SOURCES = [
    {value: "UNEP-WCMC website", details: false},
    {value: "Advertisement", details: "Please state publication"},
    {value: "Network email", details: false},
    {value: "Agency", details: false},
    {value: "Other", details: "Please state medium"}
  ]

  belongs_to :form
  has_many :field_submissions, dependent: :destroy, inverse_of: :submission

  has_attached_file :cv
  has_attached_file :cover_letter

  accepts_nested_attributes_for :field_submissions

  serialize :content, OpenStruct

  validates :form, presence: true
  validates :email, presence: true, email: true

  before_create :set_slug

  def content=(params)
    write_attribute(:content, OpenStruct.new(params))
  end

  def self.build_for_form(form)
    submission = new(form_id: form.id)
    form.fields.each do |field|
      submission.field_submissions.build(type: field.type + "Submission", field_id: field.id)
    end
    submission
  end

  def to_param
    slug
  end

  private

  def set_slug
    s = SecureRandom.hex until slug_valid?(s)
    self.slug = s
  end

  def slug_valid?(s)
    s && !self.class.find_by_slug(s)
  end

end
