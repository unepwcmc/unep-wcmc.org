class JobApplicationsController < ApplicationController
  before_action :authenticate
  before_action :set_form, only: [:show, :destroy]

  def index
    @forms = Form.order(created_at: :desc)
  end

  def show
  end

  def download_all_applications_zip
    form = Form.find(params[:id]) rescue nil
    if form.nil? || form.vacancy.nil?
      redirect_to job_applications_path, flash: { error: 'Cannot find that job application' }
      return
    end
    path = Rails.root.join('private', 'zip', 'all_job_applications')
    vacancy_label = form.vacancy.formatted_label
    last_uploaded_submission = form.submissions.order(updated_at: :asc).last
    if last_uploaded_submission.nil?
      redirect_to job_applications_path, flash: { error: 'Cannot find that job application' }
      return
    end

    filename = "#{vacancy_label}.zip"
    zip = Download::GenerateZip.new(path, filename)

    if zip.zip_needs_regenerating? last_uploaded_submission.updated_at
      zip.all_applications_generate_zip(form.id)
    end

    if zip.zip_exists?
      send_file path + filename, type: 'application/zip', disposition: 'attachment', filename: filename
    else
      redirect_to job_application_path(form), flash: { error: 'Cannot find zip file' }
    end
  end

  def download_application_zip
    submission = Submission.find_by(slug: params[:id]) rescue nil
    if submission.nil?
      redirect_to job_applications_path, flash: { error: 'Cannot find that job application' }
      return
    end
    path = Rails.root.join('private', 'zip', 'job_applications')
    vacancy_label = submission.form.vacancy.formatted_label
    filename = "#{vacancy_label}-#{submission.name.parameterize.underscore}.zip"
    zip = Download::GenerateZip.new(path, filename)

    if zip.zip_needs_regenerating? submission.updated_at
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
