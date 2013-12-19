class Employment < ActiveRecord::Base
  belongs_to :project, class_name: "Cms::Page"
  belongs_to :employee, class_name: "Cms::Page"
end
