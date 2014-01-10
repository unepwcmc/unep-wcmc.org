class AddCoverLetterAndCvToSubmissions < ActiveRecord::Migration
  def change
    add_attachment :submissions, :cv
    add_attachment :submissions, :cover_letter
  end
end
