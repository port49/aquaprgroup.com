class Link < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable
  
  scope :latest, order('created_at DESC').limit(4)

  has_attached_file :image, :styles => {
    :icon   => "21x21#",
    :thumb  => "72x72#",
    :medium => "250x250#"
  }, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"

  before_save :set_visible

  def set_visible
    self.visible = true
  end

  def before_update_pending(attrs)
    self.update_attributes(:image => attrs['image']) if attrs['image']
    super
  end
end
