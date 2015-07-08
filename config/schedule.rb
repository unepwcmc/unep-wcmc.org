every 1.day, :at => '11:30 pm' do
  command "backup perform -t wcmc_files"
  command "backup perform -t wcmc_website_db"
end
