module DonateHelper
  def top_projects
    featured_work_page = Comfy::Cms::Site.find_by(label: 'featured-projects').pages.find_by(label:'Featured Work')
    featured_work_page.children.published.where(is_top_project: true).includes(blocks: [:files])
  end
end
