class FormSubmissionsController < ApplicationController
  def new
    form = Form.find_by_vacancy_id!(params[:vacancy_id])
    @submission = Submission.build_for_form(form)
  end
end
