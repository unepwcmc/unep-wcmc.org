FactoryGirl.define do
  factory :featured_project, class: Cms::Page do
    before(:create) do |project|
      site = FactoryGirl.create(:featured_projects_site)
      layout = FactoryGirl.create(:cms_layout, site_id: site.id)
      project.layout_id = layout.id
      project.site_id = site.id
    end
    label "label"
    slug "slug"
  end

  factory :employee, class: Cms::Page do
    before(:create) do |project|
      site = FactoryGirl.create(:employees_site)
      layout = FactoryGirl.create(:cms_layout, site_id: site.id)
      project.layout_id = layout.id
      project.site_id = site.id
    end
    label "label"
    slug "slug"
  end
end
