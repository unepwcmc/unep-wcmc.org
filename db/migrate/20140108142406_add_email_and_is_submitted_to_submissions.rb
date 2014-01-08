class AddEmailAndIsSubmittedToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :email, :string, null: false
    add_column :submissions, :is_submitted, :boolean, default: false
  end
end
