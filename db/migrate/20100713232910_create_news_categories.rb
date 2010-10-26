class CreateNewsCategories < ActiveRecord::Migration
  def self.up
    create_table :news_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :news_categories
  end
end
