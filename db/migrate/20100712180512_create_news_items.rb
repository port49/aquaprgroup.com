class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.string :ipac_id
      t.string :name
      t.boolean :visible
      t.datetime :release_date
      t.string :keywords
      t.text :abstract
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :news_items
  end
end
