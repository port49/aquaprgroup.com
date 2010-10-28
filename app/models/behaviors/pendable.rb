# Store a serialized hash of an ActiveRecord instance attributes 
# in the pendings table.
module Pendable 
  # Bootstrap the class methods.
  def self.included(klass)
    klass.extend ClassMethods

    klass.scope :deleted, :conditions => { :something => true }
  end
  
  #
  # Class Methods.
  #
  module ClassMethods
    def create(attrs = nil, &block)
      new_record = super
      new_record.update_pending(attrs)
      new_record
    end
  end

  #
  # Instance Methods.
  #
  def before_update_pending(attrs={}); end
  def after_update_pending(attrs={}); end

  def update_pending(attrs)
    before_update_pending(attrs)
    make_pending unless is_pending?
    pending.update_attributes(:serialized_attributes => attrs)
    after_update_pending(attrs)
  end

  def before_publish; end
  def after_publish; end
  
  def publish!
    self.class.transaction do
      before_publish
      if is_pending?
        load_pending
        save
        pending.delete
      end
      after_publish
    end
  end
  
  def after_destroy
    pending.delete
    super
  end

  def is_pending?
    !is_published?
  end
  
  def is_published?
    pending.nil?
  end

  def load_pending
    if is_pending?
      pending_attributes = pending.serialized_attributes.stringify_keys.select{|k,v| self.has_attribute?(k)}
      self.attributes = self.attributes.merge(pending_attributes)
    end
  end

  def reset_pending
    reload
  end

private
  def pending
    Pending.where(:pendable_id => self.id, :pendable_type => self.class.name).first
  end

  def make_pending
    Pending.create(:pendable_id => self.id, :pendable_type => self.class.name)
  end
end
