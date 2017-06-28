class SubmissionMailer < ActionMailer::Base
  def save_confirmation(submission, form)
    @submission = submission
    @form = form
    if submission.saved_first_time?
      mail(from: 'no-reply@unep-wcmc.org', to: submission.email, subject: 'Job application saved.').deliver
    end
  end

  def submit_confirmation(submission, form)
    @submission = submission
    @form = form
    mail(from: 'no-reply@unep-wcmc.org', to: submission.email, subject: 'Job application submitted.').deliver
  end

  def inform_recruitment(submission, form)
    @submission = submission
    @form       = form
    @vacancy    = @form.vacancy
    @host       = default_url_options[:host]

    if @submission.cv.present?
      attachments[@submission.cv_file_name] = File.read(@submission.cv.path)
    end

    if @submission.cover_letter.present?
      attachments[@submission.cover_letter_file_name] = File.read(@submission.cover_letter.path)
    end

    if @submission.application_form.present?
      attachments[@submission.application_form_file_name] = File.read(@submission.application_form.path)
    end

    mail(
      from: 'no-reply@unep-wcmc.org',
      to: 'recruitment@unep-wcmc.org',
      subject: "Job Application submitted: #{@vacancy.label},
        #{@submission.name} (#{@submission.email})"
    ).deliver
  end
end
