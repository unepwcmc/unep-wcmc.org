namespace :import do
  desc "Import countries table"
  task countries: :environment do
    filename = Rails.root.join('lib','tasks','csv','countries_used.csv')
	  data = CSV.read(filename)
    data.each do |row|
      Api::Country.find_or_create_by_iso2_and_name(iso2: row[0], name: row[1])
	  end
  end
end
