class Download::GenerateZip

  def initialize path, zip_path
    @path = path
    @zip_path = zip_path
  end

  def add_single_application_to_zip resource_path
    system("zip -jru #{@zip_path} '#{resource_path}'", chdir: @path)
  end

  def add_many_applications_to_zip resource_path
    system("zip -ru #{@zip_path} '#{resource_path}'", chdir: @path)
  end

  def application_generate_zip submission_id
    submission = Submission.find_by(id: submission_id)
    add_single_application_to_zip(submission.cv.path)
    add_single_application_to_zip(submission.application_form.path)
    add_single_application_to_zip(submission.cover_letter.path)
  end

  def all_applications_generate_zip form_id
    form = Form.find_by(id: form_id)
    zipped_files_path = "form-#{form.vacancy.label}".parameterize.underscore
    system("mkdir #{zipped_files_path}", chdir: @path)

    form.submissions.where(is_submitted: true).each do |submission|
      candidate_path = "#{submission.name}".parameterize.underscore
      all_submissions_path = "all_submissions"

      system("mkdir #{zipped_files_path}/#{candidate_path}", chdir: @path)

      system("cp #{submission.cv.path} #{zipped_files_path}/#{candidate_path}", chdir: @path)
      system("mv #{submission.cv_file_name} #{submission.name.parameterize.underscore}_#{submission.cv_file_name}", chdir: "#{@path}/#{zipped_files_path}/#{candidate_path}")

      system("cp #{submission.application_form.path} #{zipped_files_path}/#{candidate_path}", chdir: @path)
      system("mv #{submission.application_form_file_name} #{submission.name.parameterize.underscore}_#{submission.application_form_file_name}", chdir: "#{@path}/#{zipped_files_path}/#{candidate_path}")

      system("cp #{submission.cover_letter.path} #{zipped_files_path}/#{candidate_path}", chdir: @path)
      system("mv #{submission.cover_letter_file_name} #{submission.name.parameterize.underscore}_#{submission.cover_letter_file_name}", chdir: "#{@path}/#{zipped_files_path}/#{candidate_path}")

      system("mkdir #{zipped_files_path}/#{all_submissions_path}", chdir: @path)
      system("cp #{zipped_files_path}/#{candidate_path}/* #{zipped_files_path}/#{all_submissions_path}", chdir: @path)
    end

    add_many_applications_to_zip(zipped_files_path)
    system("rm -rf #{zipped_files_path}", chdir: @path)
  end

  def zip_exists?
    system("ls #{@path}/#{@zip_path}")
  end

  def delete_zip
    system("rm -rf #{@zip_path}", chdir: @path)
  end

end
