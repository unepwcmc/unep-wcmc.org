class RenameDatasetAttachmentToDatasetField < ActiveRecord::Migration
  def change
    rename_table :dataset_attachments, :dataset_fields
  end
end
