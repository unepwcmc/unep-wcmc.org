class CreateProgrammes < ActiveRecord::Migration

  def change
    create_table :programmes do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end

end