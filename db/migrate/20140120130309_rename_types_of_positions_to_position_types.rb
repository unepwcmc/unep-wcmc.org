class RenameTypesOfPositionsToPositionTypes < ActiveRecord::Migration
  def change
    rename_table :types_of_positions, :position_types
  end
end
