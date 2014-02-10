class DropNewsReferences < ActiveRecord::Migration
  def up
    drop_table :news_references
  end

  def down
    create_table :news_references do |t|
      t.integer :news_id
      t.integer :related_news_id
    end
  end
end
