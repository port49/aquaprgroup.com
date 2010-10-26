class CreatePendingTest < ActiveRecord::Migration
  def self.up
    create_table :pending_tests do |t|
      t.string  :name
      t.text    :description

      t.timestamps
    end
  end

  def self.down
    drop_table :pending_tests
  end
end
