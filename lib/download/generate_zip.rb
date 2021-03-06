require 'zip'

class Download::GenerateZip

  def initialize path, zip_path
    @path = path
    @zip_path = zip_path
  end

  def add_documents_to_zip resource_path
    begin
      custom_system("zip -ru #{@zip_path} '#{resource_path}'", @path)
    rescue Exception => e
      Appsignal.send_error(e)
    end
  end

  def application_generate_zip submission_id
    submission = Submission.find_by(id: submission_id)
    begin
      custom_attachments_valid submission
    rescue Exception => e
      Appsignal.send_error(e)
      return
    end

    candidate_path = "#{submission.name}".parameterize.underscore
    vacancy_label = submission.form.vacancy.formatted_label
    zipped_files_path = "form-#{vacancy_label}-#{candidate_path}".parameterize.underscore
    document_path = "#{zipped_files_path}/#{vacancy_label}_#{candidate_path}"
    cv_extension = File.extname(submission.cv_file_name)
    application_form_extension = submission.application_form_file_name.present? ? File.extname(submission.application_form_file_name) : nil
    cover_letter_extension = File.extname(submission.cover_letter_file_name)
    personal_details_form_extension = submission.personal_details_form_file_name.present? ? File.extname(submission.personal_details_form_file_name) : nil

    begin
      custom_system("mkdir #{zipped_files_path}", @path)
      custom_system("cp \"#{submission.cv.path}\" #{document_path}_CV#{cv_extension}", @path)
      custom_system("cp \"#{submission.application_form.path}\" #{document_path}_Application#{application_form_extension}", @path) unless application_form_extension.nil?
      custom_system("cp \"#{submission.cover_letter.path}\" #{document_path}_Cover_letter#{cover_letter_extension}", @path)
      custom_system("cp \"#{submission.personal_details_form.path}\" #{document_path}_Personal_details#{personal_details_form_extension}", @path) unless personal_details_form_extension.nil?
      add_documents_to_zip(zipped_files_path)
      custom_system("rm -rf #{zipped_files_path}", @path)
    rescue Exception => e
      Appsignal.send_error(e)
      custom_system("rm -r #{zipped_files_path}", @path)
      return
    end
  end

  def all_applications_generate_zip form_id
    form = Form.find_by(id: form_id)
    return unless any_submissions_with_documents_valid? form
    zipped_files_path = "form-#{form.vacancy.label}".parameterize.underscore

    begin
      custom_system("mkdir #{zipped_files_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}")
    rescue Exception => e
      Appsignal.send_error(e)
      return
    end

    form.submissions.where(is_submitted: true).each do |submission|
      begin
        custom_attachments_valid submission
      rescue Exception => e
        Appsignal.send_error(e)
        next
      end

      candidate_path = "#{submission.name}".parameterize.underscore
      all_submissions_path = "all_submissions"
      vacancy_label = form.vacancy.formatted_label
      documents_path = "#{zipped_files_path}/#{candidate_path}/#{vacancy_label}_#{candidate_path}"
      cv_extension = File.extname(submission.cv_file_name)
      application_form_extension = submission.application_form_file_name.present? ? File.extname(submission.application_form_file_name) : nil
      cover_letter_extension = File.extname(submission.cover_letter_file_name)
      personal_details_form_extension = submission.personal_details_form_file_name.present? ? File.extname(submission.personal_details_form_file_name) : nil

      begin
        custom_system("mkdir #{zipped_files_path}/#{candidate_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}/#{candidate_path}")
        custom_system("cp \"#{submission.cv.path}\" #{documents_path}_CV#{cv_extension}", @path)
        custom_system("cp \"#{submission.application_form.path}\" #{documents_path}_Application#{application_form_extension}", @path) unless application_form_extension.nil?
        custom_system("cp \"#{submission.cover_letter.path}\" #{documents_path}_Cover_letter#{cover_letter_extension}", @path)
        custom_system("cp \"#{submission.personal_details_form.path}\" #{documents_path}_Personal_details#{personal_details_form_extension}", @path) unless personal_details_form_extension.nil?
        custom_system("mkdir #{zipped_files_path}/#{all_submissions_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}/#{all_submissions_path}")
        custom_system("cp #{zipped_files_path}/#{candidate_path}/* #{zipped_files_path}/#{all_submissions_path}", @path)
      rescue Exception => e
        Appsignal.send_error(e)
        next
      end
    end

    begin
      add_documents_to_zip(zipped_files_path)
      custom_system("rm -r #{zipped_files_path}", @path)
    rescue Exception => e
      Appsignal.send_error(e)
    end
  end

  def zip_exists?
    File.exists?("#{@path}/#{@zip_path}")
  end

  def zip_needs_regenerating? last_uploaded_application_time
    return true unless File.exists?("#{@path}/#{@zip_path}")

    zip_file_modification_time = File.mtime("#{@path}/#{@zip_path}")
    zip_file_modification_time < last_uploaded_application_time
  end

  def zip_contents_mismatched?(job_submissions)
    return true unless File.exists?("#{@path}/#{@zip_path}")

    # NB: This isn't taking into account personal details forms, because there are
    # still submissions for jobs (at the time of commenting) that don't have personal 
    # details forms attached, and thus wouldn't be 'valid' submissions according to the below
    valid_submissions = job_submissions.where.not(
      cv_file_name: nil, 
      cover_letter_file_name: nil, 
      application_form_file_name: nil, 
      is_submitted: false
    )

    number_of_applications = valid_submissions.pluck(:name).map(&:downcase).uniq.count 
    
    zip_file = Zip::File.open("#{@path}/#{@zip_path}")

    # Need to account as well for the all_submissions folder that's usually generated
    number_of_entries = zip_file.glob('*/*').count
    all_applications_folder = zip_file.entries.map(&:name).find do |folder|
                                folder.split('/').last == 'all_submissions'
                              end

    number_of_entries -= 1 if all_applications_folder

    number_of_entries != number_of_applications
  end

  def any_submissions_with_documents_valid? form
    form.submissions.each do |submission|
      return true if submission.attachments_valid?
    end
    return false
  end

  def delete_zip
    begin
      custom_system("rm #{@zip_path}", @path)
    rescue Exception => e
      Appsignal.send_error(e)
    end
  end

  def custom_attachments_valid submission
    unless submission.attachments_valid? then raise Exception.new("Failed attachments_valid? for slug: #{submission.slug}") end
    return true
  end

  def custom_system(command, chdir)
    system(command, chdir: chdir)
    if $? != 0 then raise Exception.new("Error with command #{command} with chdir: #{chdir}") end
  end
end
