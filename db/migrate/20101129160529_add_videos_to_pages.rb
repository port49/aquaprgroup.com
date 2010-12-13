class AddVideosToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :videos, :text
  end

  def self.down
    remove_column :pages, :videos
  end
end
