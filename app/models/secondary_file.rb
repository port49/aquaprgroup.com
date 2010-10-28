class SecondaryFile < ActiveRecord::Base
  has_attached_file :binary, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"
  belongs_to :primary_file, :polymorphic => true
  
  def make_pending_clone!
    file = Tempfile.new(self.binary_file_name)
    file.write File.open(self.binary.path).read
    file.instance_eval("def original_filename; \"#{self.binary_file_name}\"; end")
    file.instance_eval("def content_type; \"#{self.binary_content_type}\"; end")
    SecondaryFile.create(self.attributes.merge(:binary => file, :pending => true))
  end
end
