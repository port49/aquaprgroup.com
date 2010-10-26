class CreatePendingTestContainers < ActiveRecord::Migration
  def self.up
    create_table :pending_test_containers do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :pending_test_containers
  end
end
