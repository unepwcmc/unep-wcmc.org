namespace :remove do
  desc "remove cached zip files"
  task :zip_cache => [:environment] do |t, args|
    logger.info "Removing cached zip files..."

    logger.info "Removing cached zip files for all_job_applications"
    path = Rails.root.join('private', 'zip', 'all_job_applications')
    system("rm -rf *.zip", chdir: path)

    logger.info "Removing cached zip files for job_applications"
    path = Rails.root.join('private', 'zip', 'job_applications')
    system("rm -rf *.zip", chdir: path)
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/remove_zip_cache.log")
  end
end
