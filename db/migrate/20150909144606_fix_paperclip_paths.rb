class FixPaperclipPaths < ActiveRecord::Migration
  def change
    src_dir = Rails.root.join("public/system/cms")
    if Dir.exists?(src_dir)
      target_dir = Rails.root.join("public/system/comfy/cms")
      FileUtils.mv(src_dir, target_dir)
    end
    Comfy::Cms::Block.where("content LIKE '%system/cms%'").each do |b|
      b.update_attribute(:content, b.content.gsub(/system\/cms/, 'system/comfy/cms'))
    end
    execute "UPDATE comfy_cms_pages SET content_cache = NULL"
  end
end
