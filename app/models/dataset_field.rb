class DatasetField <  ActiveRecord::Base
  belongs_to :dataset, class_name: "Cms::Page"

  def removed
    @removed
  end
end
