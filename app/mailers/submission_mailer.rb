class SubmissionMailer < ActionMailer::Base
  def save_confirmation(submission, form)
    @submission = submission
    @form = form
    if submission.saved_first_time?
      mail(from: 'jobs@unep-wcmc.org', to: submission.email, subject: 'Job application saved.').deliver
    end
  end

  def submit_confirmation(submission, form)
    @submission = submission
    @form = form
    mail(from: 'jobs@unep-wcmc.org', to: submission.email, subject: 'Job application submitted.').deliver
  end
end
