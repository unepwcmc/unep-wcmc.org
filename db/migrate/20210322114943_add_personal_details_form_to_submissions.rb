class AddPersonalDetailsFormToSubmissions < ActiveRecord::Migration
  def change
    add_attachment :submissions, :personal_details_form
  end
end
