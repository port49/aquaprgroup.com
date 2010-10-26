class NewsItem < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable
  
  contained_by :news_categories

  has_attached_file :image, :styles => {
    :icon   => "21x21#",
    :thumb  => "155x155#",
    :medium => "250x250#"
  }, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"

  def before_update_pending(attrs)
    self.update_attributes(:image => attrs['image']) if attrs['image']
    super
  end
end
