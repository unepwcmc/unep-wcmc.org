namespace :unepwcmc do
  desc "Setup CMS and seed it with required sites"
  task setup: :environment do
    hostname = ENV['HOSTNAME'] || '127.0.0.1'
    sites = [
      {label: "homepage", path: ""},
      {label: "news", path: "news"},
      {label: "about-us", path: "about-us"},
      {label: "featured-projects", path: "featured-projects"},
      {label: "resources-and-data", path: "resources-and-data"},
      {label: "expertise", path: "expertise"},
      {label: "employees", path: "employees"},
      {label: "vacancies", path: "vacancies"},
      {label: "policies", path: "policies"}
    ]
    sites.each do |site|
      Cms::Site.create(label: site[:label], identifier: site[:label], path: site[:path], hostname: hostname)
      ENV['FROM'] = site[:label]
      ENV['TO'] = site[:label]
      Rake::Task["comfortable_mexican_sofa:fixtures:import"].execute
    end
  end

  desc "Changes the data inside the Database to use the basic CMS structure in a proper way"
  task refurbish: :environment do
    puts "update root pages"
    [
      {id: 1, full_path: '/', slug: 'index', site_id: 1, position: 1},
      {id: 10, full_path: '/about-us', slug: 'about-us', site_id: 1, position: 2},
      {id: 15, full_path: '/featured-projects', slug: 'featured-projects', site_id: 1, position: 3},
      {id: 29, full_path: '/resources-and-data', slug: 'resources-and-data', site_id: 1, position: 4},
      {id: 37, full_path: '/expertise', slug: 'expertise', site_id: 1, position: 5},
      {id: 48, full_path: '/employees', slug: 'employees', site_id: 1, position: 6},
      {id: 52, full_path: '/vacancies', slug: 'vacancies', site_id: 1, position: 7},
      {id: 55, full_path: '/news', slug: 'news', site_id: 1, position: 8},
      {id: 69, full_path: '/policies', slug: 'policies', site_id: 1, position: 9},
      {id: 417, full_path: '/dashboard', slug: 'dashboard', site_id: 1, position: 10},
      {id: 531, full_path: '/wcmc', slug: 'wcmc', site_id: 1, position: 11},
      {id: 549, full_path: '/terms-and-conditions', slug: 'terms-and-conditions', site_id: 1, position: 12}
    ].each do |p|
      h = Cms::Page.find(p[:id])
      h.site_id = p[:site_id]
      h.full_path = p[:full_path]
      h.slug = p[:slug]
      h.position = p[:position]
      h.save
    end
    puts "update remaining pages"
    Cms::Page.where('site_id <> 1').each do |p|
      p.site_id = 1
      p.save
    end

    puts "update layouts"
    Cms::Layout.order('site_id ASC, position ASC').each do |l|
      l.site_id = 1
      l.save
    end

    puts "remove unnecessary sites"
    Cms::Site.where('id <> 1').delete_all
  end

end
