class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.integer :vacancy_id

      t.timestamps
    end
  end
end
