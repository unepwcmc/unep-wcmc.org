class AddParentProgrammeIdToProgramme < ActiveRecord::Migration
  def change
    add_column :programmes, :parent_programme_id, :integer
  end
end
