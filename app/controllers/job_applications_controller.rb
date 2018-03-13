class JobApplicationsController < ApplicationController
  before_action :authenticate
  before_action :set_form, only: [:show]

  def index
    @forms = Form.order(created_at: :desc)
  end

  def show
  end

  def download_all_applications_zip
    form = Form.find(params[:id])
    path = Rails.root.join('private', 'zip', 'all_job_applications')
    filename = "job_application_form-#{form.vacancy.label.parameterize.underscore}-#{Date.today.to_s.parameterize.underscore}.zip"
    zip = Download::GenerateZip.new(path, filename)

    unless zip.zip_exists?
      zip.all_applications_generate_zip(form.id)
    end
    
    send_file path + filename, type: 'application/zip', disposition: 'attachment', filename: filename
  end

  def download_application_zip
    submission = Submission.find_by(slug: params[:id])
    path = Rails.root.join('private', 'zip', 'job_applications')
    filename = "job_application_submission-#{submission.name.parameterize.underscore}-#{submission.id}-#{Date.today.to_s.parameterize.underscore}.zip"
    zip = Download::GenerateZip.new(path, filename)

    unless zip.zip_exists?
      zip.application_generate_zip(submission.id)
    end

    send_file path + filename, type: 'application/zip', disposition: 'attachment', filename: filename
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def authenticate
    redirect_to new_user_session_path unless current_user
  end

end
