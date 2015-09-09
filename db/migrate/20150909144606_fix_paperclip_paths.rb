class FixPaperclipPaths < ActiveRecord::Migration
  def change
    src_dir = Rails.root.join("public/system/cms")
    if Dir.exists?(src_dir)
      target_dir = Rails.root.join("public/system/comfy/cms")
      FileUtils.mv(src_dir, target_dir)
    end
    execute "UPDATE comfy_cms_blocks SET content = regexp_replace(content, '(.+)system/cms(.+)', '\1system/comfy/cms\2', 'g') WHERE content LIKE '%system/cms%'"
    execute "UPDATE comfy_cms_pages SET content_cache = NULL"
  end
end
