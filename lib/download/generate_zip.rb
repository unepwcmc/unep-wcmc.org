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
    candidate_path = "#{submission.name}".parameterize.underscore
    vacancy_label = submission.form.vacancy.label.scan(/\((.*)\)/).first.first
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
    zipped_files_path = "form-#{form.vacancy.label}".parameterize.underscore
    system("mkdir #{zipped_files_path}", chdir: @path)

    form.submissions.where(is_submitted: true).each do |submission|
      candidate_path = "#{submission.name}".parameterize.underscore
      all_submissions_path = "all_submissions"
      vacancy_label = form.vacancy.label.scan(/\((.*)\)/).first.first
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
    system("ls #{@path}/#{@zip_path}")
  end

  def delete_zip
    system("rm -rf #{@zip_path}", chdir: @path)
  end

end
