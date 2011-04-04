class NewsItem < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable

  contained_by :news_categories
  contained_by :packages

  scope :latest, order('release_date DESC').limit(3)

  has_attached_file :image, :styles => {
    :icon   => "21x21#",
    :thumb  => "72x72#",
    :medium => "250x250#"
  }, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"

  # tsearch
  index do
    name
    body
  end

  def before_update_pending(attrs)
    self.update_attributes(:image => attrs['image']) if attrs['image']
    super
  end
end
