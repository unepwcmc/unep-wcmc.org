namespace :unepwcmc do
  desc "Setup CMS and seed it with required sites"
  task setup: :environment do
    hostname = ENV['HOSTNAME'] || '127.0.0.1'
    sites = [
      {label: "homepage", path: ""},
      {label: "about-us", path: "about-us"},
      {label: "featured-projects", path: "featured-projects"},
      {label: "resources-and-data", path: "resources-and-data"},
      {label: "expertise", path: "expertise"},
      {label: "employees", path: "employees"},
      {label: "vacancies", path: "vacancies"}
    ]
    sites.each do |site|
      Cms::Site.create(label: site[:label], identifier: site[:label], path: site[:path], hostname: hostname)
      ENV['FROM'] = site[:label]
      ENV['TO'] = site[:label]
      Rake::Task["comfortable_mexican_sofa:fixtures:import"].execute
    end
  end

end
