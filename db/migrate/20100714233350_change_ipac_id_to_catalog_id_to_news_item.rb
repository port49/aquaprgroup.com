class ChangeIpacIdToCatalogIdToNewsItem < ActiveRecord::Migration
  def self.up
    rename_column :news_items, :ipac_id, :catalog_id
  end

  def self.down
    rename_column :news_items, :catalog_id, :ipac_id
  end
end
