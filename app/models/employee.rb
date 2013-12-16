class Employee < ActiveRecord::Base
  has_attached_file :photo
  validates :name, presence: true
end
