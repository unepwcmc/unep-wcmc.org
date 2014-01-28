class Attachment < ActiveRecord::Base
  belongs_to :form
  has_attached_file :file
end
