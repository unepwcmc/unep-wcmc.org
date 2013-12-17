class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.integer :employee_id
      t.integer :project_id
      t.string  :role
      t.timestamps
    end
  end
end
