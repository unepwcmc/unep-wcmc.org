FactoryGirl.define do
  factory :featured_project, class: Comfy::Cms::Page do
    before(:create) do |project|
      site = FactoryGirl.create(:featured_projects_site)
      layout = FactoryGirl.create(:cms_layout, site_id: site.id)
      project.layout_id = layout.id
      project.site_id = site.id
    end
    label "label"
    slug "slug"
  end

  factory :employee, class: Comfy::Cms::Page do
    before(:create) do |project|
      site = FactoryGirl.create(:employees_site)
      layout = FactoryGirl.create(:cms_layout, site_id: site.id)
      project.layout_id = layout.id
      project.site_id = site.id
    end
    label "label"
    slug "slug"
  end

  factory :homepage, class: Comfy::Cms::Page do
    before(:create) do |page|
      site = FactoryGirl.create(:homepage_site)
      layout = FactoryGirl.create(:cms_layout, site_id: site.id)
      page.layout_id = layout.id
      page.site_id = site.id
    end
    label "homepage"
    slug "index"
  end

  factory "404", class: Comfy::Cms::Page do
    before(:create) do |page|
      parent = FactoryGirl.create(:homepage)
      page.layout_id = parent.layout_id
      page.site_id = parent.site_id
      page.parent_id = parent.id
    end
    label "404"
    slug "404"
  end
end
