class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :form_id
      t.string :name
    end
    add_attachment :attachments, :file
  end
end
