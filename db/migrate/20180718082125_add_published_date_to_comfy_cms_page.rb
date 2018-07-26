class AddPublishedDateToComfyCmsPage < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :published_date, :datetime

    Comfy::Cms::Page.find_each do |page|
      page.published_date = page.created_at
      page.save!
    end
  end
end
