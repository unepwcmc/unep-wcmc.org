FactoryGirl.define do
  factory :featured_projects_site, class: Comfy::Cms::Site do
    identifier "featured-projects"
    label "Featured Projects"
    hostname "127.0.0.1"
  end

  factory :employees_site, class: Comfy::Cms::Site do
    identifier "employees"
    label "Employees"
    hostname "127.0.0.1"
  end
end
