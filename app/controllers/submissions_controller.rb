class SubmissionsController < ApplicationController
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
      flash.now[:success] = "Your submission has been saved"
      redirect_to action: :edit, id: @submission.slug
    else
      render action: :new
    end
  end

  def update
    @form = Form.find(params[:form_id])
    @submission = @form.submissions.find_by_slug!(params[:id])
    @submission.is_submitted ||= !!params[:submit]
    if @submission.update(submission_params)
      flash.now[:success] = "Your submission has been saved"
      redirect_to action: :edit, id: @submission.slug
    else
      render action: :edit
    end
  end

  private

  def submission_params
    params.require(:submission).permit(:email, field_submissions_attributes: [:id, :content, :field_id, :type, :file])
  end
end
