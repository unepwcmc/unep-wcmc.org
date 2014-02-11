class SubmissionsController < ApplicationController
  before_action :build_reference_details, only: [:create, :update]
  before_action :find_form
  before_action :find_submission, only: [:edit, :update]

  def new
    @submission = Submission.build_for_form(@form)
  end

  def edit
  end

  def show
    @submission = @form.submissions.where(is_submitted: true).find_by_slug!(params[:id])
  end

  def create
    @submission = @form.submissions.build(submission_params)
    @submission.is_submitted ||= !!params[:submit]
    if @submission.save
      send_confirmation_email
      flash[:success] = success_message
      redirect_to action: :edit, id: @submission.slug
    else
      flash.now[:error] = failure_message
      render action: :new
    end
  end

  def update
    @submission.is_submitted ||= !!params[:submit]
    if @submission.update(submission_params)
      send_confirmation_email
      flash[:success] = success_message
      redirect_to action: :edit, id: @submission.slug
    else
      flash.now[:error] = failure_message
      render action: :edit
    end
  end

  private

  def find_submission
    @submission = @form.submissions.where(is_submitted: false).find_by_slug!(params[:id])
  end

  def success_message
    if @submission.is_submitted
      'Application sent! You\'ll shortly receive a confirmation email.'
    elsif @submission.saved_first_time?
      'The submission draft has been saved. You\'ll shortly receive an email with a link for further editing'
    else
      'The submission draft has been saved. You can still edit it later.'
    end
  end

  def failure_message
    if params[:submit]
      "We couldn't submit your application, please fix the errors and try again."
    else
      "We couldn't save your application, please fix the errors and try again."
    end
  end

  def send_confirmation_email
    if params[:submit]
      SubmissionMailer.submit_confirmation(@submission, @form)
    else
      SubmissionMailer.save_confirmation(@submission, @form)
    end
  end

  def find_form
    @form = Form.find(params[:form_id])
  end

  def submission_params
    params.require(:submission).permit(:cv, :cover_letter, :name, :phone, :email, field_submissions_attributes: [:id, :content, :field_id, :type, :file], content: Submission::ALLOWED_CONTENT_FIELDS)
  end

  def build_reference_details
    params[:submission][:content][:reference_details] = params[:submission][:content][:reference_details][params[:submission][:content][:reference]]
  end
end
