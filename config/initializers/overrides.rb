Comfy::Cms::Page.class_eval do
  scope :published, -> { unscoped.where('published_date <= ? AND is_published = true', Date.today) }
end
