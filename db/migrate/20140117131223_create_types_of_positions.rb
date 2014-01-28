class CreateTypesOfPositions < ActiveRecord::Migration
  def change
    create_table :types_of_positions do |t|
      t.string :name
    end
  end
end
