class AddProgrammeIdToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :programme_id, :integer
  end
end
