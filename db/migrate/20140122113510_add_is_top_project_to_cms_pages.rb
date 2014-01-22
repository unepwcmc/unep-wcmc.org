class AddIsTopProjectToCmsPages < ActiveRecord::Migration
  def change
    add_column :cms_pages, :is_top_project, :boolean, default: false
  end
end
