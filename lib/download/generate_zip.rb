class Download::GenerateZip

  def initialize zip_path
    puts "initialize generate zip with the path of the zip path"
    @zip_path = zip_path
  end

  def add_to_zip resource_path
    puts "add file or directory to zip and creates zip if not already present"
    system("zip -jru #{@zip_path} #{resource_path}")
  end

  def application_generate_zip submission_id
    puts "generate zip for single job application"
    submission = Submission.find_by(id: submission_id)
    add_to_zip(submission.cv.path)
    add_to_zip(submission.application_form.path)
    add_to_zip(submission.cover_letter.path)
  end

  def all_applications_generate_zip form_id
    puts "generate zip for all applications"
  end

end
