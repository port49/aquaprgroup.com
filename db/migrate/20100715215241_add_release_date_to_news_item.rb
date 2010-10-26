class AddReleaseDateToNewsItem < ActiveRecord::Migration
  def self.up
    remove_column :news_items, :release_date
    add_column :news_items, :release_date, :date
  end

  def self.down
    remove_column :news_items, :release_date
    add_column :news_items, :release_date, :datetime
  end
end
