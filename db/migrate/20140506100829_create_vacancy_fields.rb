class CreateVacancyFields < ActiveRecord::Migration
  def change
    create_table :vacancy_fields do |t|
      t.integer :vacancy_id
      t.string :label
      t.string :url
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at

      t.timestamps
    end
  end
end
