class CreateSplashImages < ActiveRecord::Migration
  def self.up
    create_table :splash_images do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :binary_file_name
      t.string :binary_content_type
      t.integer :binary_file_size
      t.datetime :binary_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :splash_images
  end
end
