class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :form_id
      t.string :slug

      t.timestamps
    end
  end
end
