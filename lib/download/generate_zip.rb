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

    begin
      custom_system("mkdir #{zipped_files_path}", @path)
      custom_system("cp \"#{submission.cv.path}\" #{document_path}_CV#{cv_extension}", @path)
      custom_system("cp \"#{submission.application_form.path}\" #{document_path}_Application#{application_form_extension}", @path) unless application_form_extension.nil?
      custom_system("cp \"#{submission.cover_letter.path}\" #{document_path}_Cover_letter#{cover_letter_extension}", @path)
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

      begin
        custom_system("mkdir #{zipped_files_path}/#{candidate_path}", @path) unless Dir.exists?("#{@path}/#{zipped_files_path}/#{candidate_path}")

        custom_system("cp \"#{submission.cv.path}\" #{documents_path}_CV#{cv_extension}", @path)
        custom_system("cp \"#{submission.application_form.path}\" #{documents_path}_Application#{application_form_extension}", @path) unless application_form_extension.nil?
        custom_system("cp \"#{submission.cover_letter.path}\" #{documents_path}_Cover_letter#{cover_letter_extension}", @path)

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
    # Need to account as well for the all_submissions folder that's generated
    number_of_applications = job_submissions.pluck(:name).uniq.count + 1

    number_of_entries = Zip::File.open("#{@path}/#{@zip_path}") do |zip_file|
      # Subtract one because size takes into account the actual file itself
                          zip_file.size - 1
                        end

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
