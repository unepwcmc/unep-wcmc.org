class AddPositionToProgrammes < ActiveRecord::Migration
  def change
    add_column :programmes, :position, :integer
  end
end
