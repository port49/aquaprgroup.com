class CreatePendings < ActiveRecord::Migration
  def self.up
    create_table :pendings do |t|
      t.integer :pendable_id
      t.string  :pendable_type
      t.text    :serialized_attributes

      t.timestamps
    end
  end

  def self.down
    drop_table :pendings
  end
end
