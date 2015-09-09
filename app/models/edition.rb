# Instance of this model is automatically created
# when admin updates content of any CMS page.

class Edition < ActiveRecord::Base
  belongs_to :resource, class_name: "Comfy::Cms::Page"
  belongs_to :user
end
