class Programme < ActiveRecord::Base
  has_many :employments, dependent: :destroy
end
