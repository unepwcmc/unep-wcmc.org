class SubmissionMailer < ActionMailer::Base
  def save_confirmation(submission, form)
    @submission = submission
    @form = form
    if submission.saved_first_time?
      mail(to: submission.email, subject: 'Job application saved.').deliver
    end
  end
end
