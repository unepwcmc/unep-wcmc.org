class AddApplicationFormToSubmissions < ActiveRecord::Migration
  def change
    add_attachment :submissions, :application_form
  end
end
