class CreateFieldSubmissions < ActiveRecord::Migration
  def change
    create_table :field_submissions do |t|
      t.integer :field_id
      t.integer :submission_id
      t.string :type
      t.text :content

      t.timestamps
    end

    add_attachment :field_submissions, :file
  end
end
