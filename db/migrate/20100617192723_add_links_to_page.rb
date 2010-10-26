class AddLinksToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :links, :text
  end

  def self.down
    remove_column :pages, :links
  end
end
