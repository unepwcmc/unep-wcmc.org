class PositionType < ActiveRecord::Base
  scope :cms_collection, lambda { |*args| where(:is_grade => args[0]) }
end
