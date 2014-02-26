class AddTypeToDatasetFields < ActiveRecord::Migration
  def change
    add_column :dataset_fields, :type, :string
  end
end
