class CreateExternalXmlResources < ActiveRecord::Migration
  def self.up
    create_table :external_xml_resources do |t|
      t.string :name
      t.string :url
      t.integer :refresh_rate
      t.boolean :refreshing
      t.text :xml

      t.timestamps
    end
  end

  def self.down
    drop_table :external_xml_resources
  end
end
