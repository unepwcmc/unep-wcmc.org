class AddUniqueIndexOnSubmissionSlug < ActiveRecord::Migration
  def change
    add_index :submissions, :slug, unique: true
  end
end
