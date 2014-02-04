class CreateNewsReference < ActiveRecord::Migration
  def change
    create_table :news_references do |t|
      t.integer :news_id
      t.integer :related_news_id
    end
  end
end
