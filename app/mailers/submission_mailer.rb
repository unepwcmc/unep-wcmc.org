class SubmissionMailer < ActionMailer::Base

  def save_confirmation(submission, form)
    @submission = submission
    @form = form
    if submission.saved_first_time?
      mail(from: 'no-reply@unep-wcmc.org', to: submission.email, subject: 'Job application saved.')
    end
  end

  def submit_confirmation(submission, form)
    @submission = submission
    @form = form
    mail(from: 'no-reply@unep-wcmc.org', to: submission.email, subject: 'Job application submitted.')
  end

  def inform_recruitment(submission, form)
    @submission = submission
    @form       = form
    @vacancy    = @form.vacancy
    @host       = default_url_options[:host]

    mail(
      from: 'no-reply@unep-wcmc.org',
      to: 'recruitment@unep-wcmc.org',
      subject: "Job Application submitted: #{@vacancy.label},
        #{@submission.name} (#{@submission.email})"
    )
  end
end
