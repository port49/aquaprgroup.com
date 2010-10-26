class AddImageCaptionToNewsItem < ActiveRecord::Migration
  def self.up
    add_column :news_items, :image_caption, :text
  end

  def self.down
    remove_column :news_items, :image_caption
  end
end
