class AddPersonalInfoAndContentToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :name, :string
    add_column :submissions, :phone, :string
    add_column :submissions, :content, :text
  end
end
