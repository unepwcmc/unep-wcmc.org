class CreateDatasetAttachments < ActiveRecord::Migration
  def change
    create_table :dataset_attachments do |t|
      t.integer :dataset_id
      t.string :label
      t.string :url
    end
    add_attachment :dataset_attachments, :file
  end
end
