class Video < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable

  contained_by :video_categories
  contained_by :packages

  has_many :secondary_files, :as => :primary_file, :conditions => {:pending => false}, :dependent => :destroy
  has_many :pending_secondary_files, :as => :primary_file, :conditions => {:pending => true}, :class_name => 'SecondaryFile', :dependent => :destroy
  attr_accessor :pending_secondary_files_attr

  has_attached_file :image, :styles => {
    :icon   => "21x",
    :thumb  => "155x",
    :medium => "250x"
  }, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"

  def before_update_pending(attrs)
    self.update_attributes(:image => attrs['image']) if attrs['image']
    
    # create all pending secondary files
    if attrs[:pending_secondary_files_attr]
      attrs[:pending_secondary_files_attr].each do |secondary_file|
        s = SecondaryFile.create(secondary_file.merge(:pending => true, :primary_file_id => self.id, :primary_file_type => self.class.name))
      end
    end

    super
  end

  def after_publish
    # remove the published secondary files
    self.reload.secondary_files.clear
    # make the pending secondary files published
    self.pending_secondary_files.each do |secondary_file|
      secondary_file.update_attributes(:pending => false)
      # make a new pending copy of the newly published file
      secondary_file.make_pending_clone!
    end

    super
  end

end
