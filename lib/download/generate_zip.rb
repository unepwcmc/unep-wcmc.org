class Download::GenerateZip

  def initialize zip_path
    @zip_path = zip_path
  end

  def add_single_application_to_zip resource_path
    system("zip -jru #{@zip_path} '#{resource_path}'")
  end

  def add_many_applications_to_zip resource_path
    system("zip -ru #{@zip_path} '#{resource_path}'")
  end

  def application_generate_zip submission_id
    submission = Submission.find_by(id: submission_id)
    add_single_application_to_zip(submission.cv.path)
    add_single_application_to_zip(submission.application_form.path)
    add_single_application_to_zip(submission.cover_letter.path)
  end

  def all_applications_generate_zip form_id
    form = Form.find_by(id: form_id)
    system("mkdir 'form-#{form.vacancy.label}'")

    form.submissions.each do |submission|
      system("mkdir 'form-#{form.vacancy.label}/#{submission.name}'")
      system("cp #{submission.cv.path} 'form-#{form.vacancy.label}/#{submission.name}'")
      system("cp #{submission.application_form.path} 'form-#{form.vacancy.label}/#{submission.name}'")
      system("cp #{submission.cover_letter.path} 'form-#{form.vacancy.label}/#{submission.name}'")
    end

    add_many_applications_to_zip("form-#{form.vacancy.label}")
    system("rm -rf 'form-#{form.vacancy.label}'")
  end

  def delete_zip
    system("rm -rf '#{@zip_path}'")
  end

end
