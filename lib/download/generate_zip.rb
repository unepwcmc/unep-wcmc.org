class Download::GenerateZip

  def initialize path, zip_path
    @path = path
    @zip_path = zip_path
  end

  def add_documents_to_zip resource_path
    logged_system_call("zip -ru #{@zip_path} '#{resource_path}'", @path)
  end

  def application_generate_zip submission_id
    submission = Submission.find_by(id: submission_id)
    unless submission.attachments_valid?
      logger.error "Failed attachments_valid? for #{submission.inspect}" && return
    end
    candidate_path = "#{submission.name}".parameterize.underscore
    vacancy_label = submission.form.vacancy.formatted_label
    zipped_files_path = "form-#{vacancy_label}-#{candidate_path}".parameterize.underscore
    document_path = "#{zipped_files_path}/#{vacancy_label}_#{candidate_path}"
    cv_extension = File.extname(submission.cv_file_name)
    application_form_extension = File.extname(submission.application_form_file_name)
    cover_letter_extension = File.extname(submission.cover_letter_file_name)

    logged_system_call("mkdir #{zipped_files_path}", @path)
    logged_system_call("cp \"#{submission.cv.path}\" #{document_path}_CV#{cv_extension}", @path)
    logged_system_call("cp \"#{submission.application_form.path}\" #{document_path}_Application#{application_form_extension}", @path)
    logged_system_call("cp \"#{submission.cover_letter.path}\" #{document_path}_Cover_letter#{cover_letter_extension}", @path)

    add_documents_to_zip(zipped_files_path)

    logged_system_call("rm -rf #{zipped_files_path}", @path)
  end

  def all_applications_generate_zip form_id
    form = Form.find_by(id: form_id)
    return unless any_submissions_with_documents_valid? form
    zipped_files_path = "form-#{form.vacancy.label}".parameterize.underscore
    logged_system_call("mkdir #{zipped_files_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}")

    form.submissions.where(is_submitted: true).each do |submission|
      next unless submission.attachments_valid?
      candidate_path = "#{submission.name}".parameterize.underscore
      all_submissions_path = "all_submissions"
      vacancy_label = form.vacancy.formatted_label
      documents_path = "#{zipped_files_path}/#{candidate_path}/#{vacancy_label}_#{candidate_path}"
      cv_extension = File.extname(submission.cv_file_name)
      application_form_extension = File.extname(submission.application_form_file_name)
      cover_letter_extension = File.extname(submission.cover_letter_file_name)

      logged_system_call("mkdir #{zipped_files_path}/#{candidate_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}/#{candidate_path}")

      logged_system_call("cp \"#{submission.cv.path}\" #{documents_path}_CV#{cv_extension}", @path)
      logged_system_call("cp \"#{submission.application_form.path}\" #{documents_path}_Application#{application_form_extension}", @path)
      logged_system_call("cp \"#{submission.cover_letter.path}\" #{documents_path}_Cover_letter#{cover_letter_extension}", @path)

      logged_system_call("mkdir #{zipped_files_path}/#{all_submissions_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}/#{all_submissions_path}")
      logged_system_call("cp #{zipped_files_path}/#{candidate_path}/* #{zipped_files_path}/#{all_submissions_path}", @path)
    end

    add_documents_to_zip(zipped_files_path)
    logged_system_call("rm -rf #{zipped_files_path}", @path)
  end

  def zip_exists?
    File.exists?("#{@path}/#{@zip_path}")
  end

  def zip_needs_regenerating? last_uploaded_application_time
    return true unless File.exists?("#{@path}/#{@zip_path}")

    zip_file_modification_time = File.mtime("#{@path}/#{@zip_path}")
    zip_file_modification_time < last_uploaded_application_time
  end

  def any_submissions_with_documents_valid? form
    form.submissions.each do |submission|
      return true if submission.attachments_valid?
    end
    return false
  end

  def delete_zip
    logged_system_call("rm -rf #{@zip_path}", @path)
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/generate_zip.log")
  end

  def logged_system_call(command, chdir)
    result = system(command, chdir: chdir)
    unless result
      e = StandardError.new("Error with command #{command} with path: #{@path}")
      Appsignal.send_error(e)
    end
  end

end
