class AddIsGradeToPositionTypes < ActiveRecord::Migration
  def change
    add_column :position_types, :is_grade, :boolean
  end
end
