class SubmissionsController < ApplicationController
  before_action :build_reference_details, only: [:create, :update]

  def new
    @form = Form.find(params[:form_id])
    @submission = Submission.build_for_form(@form)
  end

  def edit
    @form = Form.find(params[:form_id])
    @submission = @form.submissions.find_by_slug!(params[:id])
  end

  def create
    @form = Form.find(params[:form_id])
    @submission = @form.submissions.build(submission_params)
    @submission.is_submitted ||= !!params[:submit]
    if @submission.save
      flash[:success] = "Application sent! You'll shortly receive a confirmation email."
      redirect_to action: :edit, id: @submission.slug
    else
      flash.now[:error] = "We couldn't submit your application, please try again."
      render action: :new
    end
  end

  def update
    @form = Form.find(params[:form_id])
    @submission = @form.submissions.find_by_slug!(params[:id])
    @submission.is_submitted ||= !!params[:submit]
    if @submission.update(submission_params)
      flash[:success] = "Your submission has been saved."
      redirect_to action: :edit, id: @submission.slug
    else
      flash.now[:error] = "We couldn't submit your application, please try again."
      render action: :edit
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:cv, :cover_letter, :name, :phone, :email, field_submissions_attributes: [:id, :content, :field_id, :type, :file], content: Submission::ALLOWED_CONTENT_FIELDS)
  end

  def build_reference_details
    params[:submission][:content][:reference_details] = params[:submission][:content][:reference_details][params[:submission][:content][:reference]]
  end
end
