class CreateContainers < ActiveRecord::Migration
  def self.up
    create_table :containers do |t|
      t.integer :item_id
      t.string :item_type
      t.integer :container_id
      t.string :container_type
      t.boolean :pending

      t.timestamps
    end
  end

  def self.down
    drop_table :containers
  end
end
