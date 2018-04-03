class JobApplicationsController < ApplicationController
  before_action :authenticate
  before_action :set_form, only: [:show, :destroy]

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

    if zip.zip_exists?
      send_file path + filename, type: 'application/zip', disposition: 'attachment', filename: filename
    else
      redirect_to job_application_path(form), flash: { error: 'Cannot find zip file' }
    end
  end

  def download_application_zip
    submission = Submission.find_by(slug: params[:id])
    path = Rails.root.join('private', 'zip', 'job_applications')
    vacancy_label = submission.form.vacancy.label.scan(/\(([^)]+)\)/).first.first
    filename = "job_application_submission-#{submission.name.parameterize.underscore}-#{vacancy_label}-#{Date.today.to_s.parameterize.underscore}.zip"
    zip = Download::GenerateZip.new(path, filename)

    unless zip.zip_exists?
      zip.application_generate_zip(submission.id)
    end

    if zip.zip_exists?
      send_file path + filename, type: 'application/zip', disposition: 'attachment', filename: filename
    else
      redirect_to job_application_path(submission.form), flash: { error: 'Cannot find zip file' }
    end
  end

  def destroy
    @form.submissions.each do |submission|
      submission.destroy
    end
    redirect_to job_applications_path, notice: 'Job applications were successfully destroyed.'
  end

  private

  def set_form
    @form = Form.find(params[:id])
  end

  def authenticate
    redirect_to new_user_session_path unless current_user
  end

end
