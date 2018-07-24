class AddPublishedDateToComfyCmsPage < ActiveRecord::Migration
  def change
    add_column :comfy_cms_pages, :published_date, :datetime, default: Date.today
  end
end
