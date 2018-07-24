Comfy::Cms::Page.class_eval do
  before_save :extract_published_date

  scope :published, -> { unscoped.where('published_date <= ? AND is_published = true', Date.today) }

  private

  def extract_published_date
    self.blocks_attributes.map do |attr|
      if attr[:identifier] == "time"
        self.published_date = attr[:content]
        return
      end
    end
  end
end
