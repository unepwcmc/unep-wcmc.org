class Download::GenerateZip

  def initialize path, zip_path
    @path = path
    @zip_path = zip_path
  end

  def add_documents_to_zip resource_path
    system("zip -ru #{@zip_path} '#{resource_path}'", chdir: @path)
  end

  def application_generate_zip submission_id
    submission = Submission.find_by(id: submission_id)
    return unless submission.attachments_valid?
    candidate_path = "#{submission.name}".parameterize.underscore
    vacancy_label = submission.form.vacancy.formatted_label
    zipped_files_path = "form-#{vacancy_label}-#{candidate_path}".parameterize.underscore
    document_path = "#{zipped_files_path}/#{vacancy_label}_#{candidate_path}"
    cv_extension = File.extname(submission.cv_file_name)
    application_form_extension = File.extname(submission.application_form_file_name)
    cover_letter_extension = File.extname(submission.cover_letter_file_name)

    system("mkdir #{zipped_files_path}", chdir: @path)

    system("cp #{submission.cv.path} #{document_path}_CV#{cv_extension}", chdir: @path)
    system("cp #{submission.application_form.path} #{document_path}_Application#{application_form_extension}", chdir: @path)
    system("cp #{submission.cover_letter.path} #{document_path}_Cover_letter#{cover_letter_extension}", chdir: @path)

    add_documents_to_zip(zipped_files_path)

    system("rm -rf #{zipped_files_path}", chdir: @path)
  end

  def all_applications_generate_zip form_id
    form = Form.find_by(id: form_id)
    return unless all_documents_valid? form
    zipped_files_path = "form-#{form.vacancy.label}".parameterize.underscore
    system("mkdir #{zipped_files_path}", chdir: @path)

    form.submissions.where(is_submitted: true).each do |submission|
      next unless submission.attachments_valid?
      candidate_path = "#{submission.name}".parameterize.underscore
      all_submissions_path = "all_submissions"
      vacancy_label = form.vacancy.formatted_label
      documents_path = "#{zipped_files_path}/#{candidate_path}/#{vacancy_label}_#{candidate_path}"
      cv_extension = File.extname(submission.cv_file_name)
      application_form_extension = File.extname(submission.application_form_file_name)
      cover_letter_extension = File.extname(submission.cover_letter_file_name)

      system("mkdir #{zipped_files_path}/#{candidate_path}", chdir: @path)

      system("cp #{submission.cv.path} #{documents_path}_CV#{cv_extension}", chdir: @path)
      system("cp #{submission.application_form.path} #{documents_path}_Application#{application_form_extension}", chdir: @path)
      system("cp #{submission.cover_letter.path} #{documents_path}_Cover_letter#{cover_letter_extension}", chdir: @path)

      system("mkdir #{zipped_files_path}/#{all_submissions_path}", chdir: @path)
      system("cp #{zipped_files_path}/#{candidate_path}/* #{zipped_files_path}/#{all_submissions_path}", chdir: @path)
    end

    add_documents_to_zip(zipped_files_path)
    system("rm -rf #{zipped_files_path}", chdir: @path)
  end

  def zip_exists?
    File.exists?("#{@path}/#{@zip_path}")
  end

  def zip_needs_regenerating? last_uploaded_application_time
    return true unless File.exists?("#{@path}/#{@zip_path}")

    zip_file_modification_time = File.mtime("#{@path}/#{@zip_path}")
    zip_file_modification_time < last_uploaded_application_time
  end

  def all_documents_valid? form
    form.submissions.each do |submission|
      return true if submission.attachments_valid?
    end
    return false
  end

  def delete_zip
    system("rm -rf #{@zip_path}", chdir: @path)
  end

end
