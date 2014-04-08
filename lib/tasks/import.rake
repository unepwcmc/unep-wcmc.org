namespace :import do
  desc "Import countries table"
  task countries: :environment do
    filename = Rails.root.join('lib','tasks','csv','countries_used.csv')
	  data = CSV.read(filename)
    data.each do |row|
      Country.create!({iso2: row[0], name: row[1]})
	  end
  end
end