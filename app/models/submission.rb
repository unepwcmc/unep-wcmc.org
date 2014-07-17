# Represents concrete instance of Form filled with data
# by a candidate.

class Submission < ActiveRecord::Base

  MANDATORY_CONTENT_FIELDS = [:uk_working_ability, :last_salary, :benefits, :interview_availability, :notice_period]
  ALLOWED_CONTENT_FIELDS = MANDATORY_CONTENT_FIELDS + [:uk_working_ability_details, :reference, :reference_details]

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
  has_attached_file :application_form

  accepts_nested_attributes_for :field_submissions

  serialize :content, OpenStruct

  validates :form, presence: true
  validates :email, presence: true, email: true
  validates :name, presence: true, if: :is_submitted
  validates :phone, presence: true, if: :is_submitted
  validates :cv, presence: true, if: :is_submitted
  validates :cover_letter, presence: true, if: :is_submitted
  validates :application_form, presence: true,
    if: Proc.new{|a| a.is_submitted? && a.vacancy_has_application_form? }

  validate :content_presence

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

  def saved_first_time?
    created_at == updated_at
  end

  def to_param
    slug
  end

  def vacancy_has_application_form?
    file_fields = VacancyField.for_vacancy(self.form.vacancy)
    return false if !file_fields || file_fields.empty?
    file_fields.map(&:label).include?("Application form")
  end

  private

  def set_slug
    s = SecureRandom.hex until slug_valid?(s)
    self.slug = s
  end

  def slug_valid?(s)
    s && !self.class.find_by_slug(s)
  end

  def content_presence
    MANDATORY_CONTENT_FIELDS.each do |field|
      errors.add(field, "can't be blank") unless content.send(field).present?
    end
  end

end
