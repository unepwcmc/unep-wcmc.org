class Vacancy < Comfy::Cms::Page

  has_many :forms

  def formatted_label
    job_code = label.scan(/\((.*)\)/)
    return "unknown_job_code" unless job_code.present?
    job_code.first.first.parameterize.underscore
  end

end
