class Package < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable
  
  contains :avm_images
  contains :videos
  contains :news_items
  
  has_many :containers, :conditions => ["containers.pending=?", false], :as => :container, :dependent => :destroy
  has_many :pending_containers, :conditions => ["containers.pending=?", true], :as => :container, :dependent => :destroy

  def pending_items
    @pending_items ||= pending_containers.collect{|c| c.item_type.classify.constantize.unscoped.find(c.item_id)}
  end

  def append_pending_item(item)
    Container.create(:item_id => item.id, :item_type => item.class.name, :container_id => self.id, :container_type => self.class.name, :pending => true)
  end

  def remove_all_pending_items
    self.remove_all_pending_avm_images
    self.remove_all_pending_videos
    self.remove_all_pending_news_items
  end

  def set_pending_items(items)
    self.remove_all_pending_items
    items.each do |item|
      append_pending_item(item)
    end
  end
  
  # published (and visible) containments
  def items
    @items ||= containers.collect(&:item).compact
  end

  def publish_items!
    self.containers.delete_all
    self.pending_items.each do |item|
      Container.create(:item_id => item.id, :item_type => item.class.name, :container_id => self.id, :container_type => self.class.name, :pending => false)
    end
  end
  
  def after_publish
    self.publish_items!
    super
  end
end
