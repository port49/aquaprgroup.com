# Generalization of has_many, :through
module Containable
  # Bootstrap the class methods.
  def self.included(klass)
    klass.extend ClassMethods
  end
  
  #
  # Class Methods.
  #
  module ClassMethods
    def contains(item_names)
      item_names = item_names.to_s
      item_name  = item_names.singularize
      item_class = item_name.classify.constantize

      # pending containments
      define_method("pending_#{item_names}".to_sym, lambda{
        item_class.unscoped.joins("INNER JOIN containers ON containers.item_id=#{item_names}.id").where(["containers.item_type=? AND containers.container_id=? AND containers.container_type=? AND containers.pending=?", item_class.name, self.id, self.class.name, true])
      })

      define_method("append_pending_#{item_name}".to_sym, lambda{|item|
        Container.create(:item_id => item.id, :item_type => item.class.name, :container_id => self.id, :container_type => self.class.name, :pending => true)
      })

      define_method("remove_all_pending_#{item_names}".to_sym, lambda{
        Container.where(:item_type => item_class.name, :container_id => self.id, :container_type => self.class.name, :pending => true).delete_all
      })

      define_method("set_pending_#{item_names}".to_sym, lambda{|items|
        self.send("remove_all_pending_#{item_names}".to_sym)
        items.each do |item|
          self.send("append_pending_#{item_name}".to_sym, item)
        end
      })

      # published containments
      define_method(item_names.to_sym, lambda{
        item_class.joins("INNER JOIN containers ON containers.item_id=#{item_names}.id").where(["containers.item_type=? AND containers.container_id=? AND containers.container_type=? AND containers.pending=?", item_class.name, self.id, self.class.name, false])
      })

      define_method("publish_#{item_names}!".to_sym, lambda{
        Container.where(:item_type => item_class.name, :container_id => self.id, :container_type => self.class.name, :pending => false).delete_all
        self.send("pending_#{item_names}".to_sym).each do |item|
          Container.create(:item_id => item.id, :item_type => item.class.name, :container_id => self.id, :container_type => self.class.name, :pending => false)
        end
      })

      define_method(:after_publish, lambda{
        self.send("publish_#{item_names}!".to_sym)
        super()
      })

    end

    def contained_by(container_names)
      container_names = container_names.to_s
      container_name  = container_names.singularize
      container_class = container_name.classify.constantize

      # pending containments
      define_method("pending_#{container_names}".to_sym, lambda{
        container_class.joins("INNER JOIN containers ON containers.container_id=#{container_names}.id").where(["containers.item_id=? AND containers.item_type=? AND containers.container_type=? AND containers.pending=?", self.id, self.class.name, container_class.name, true])
      })

      define_method("append_pending_#{container_name}".to_sym, lambda{|container|
        Container.create(:item_id => self.id, :item_type => self.class.name, :container_id => container.id, :container_type => container.class.name, :pending => true)
      })

      define_method("remove_all_pending_#{container_names}".to_sym, lambda{
        Container.where(:item_id => self.id, :item_type => self.class.name, :container_type => container_class.name, :pending => true).delete_all
      })

      define_method("set_pending_#{container_names}".to_sym, lambda{|containers|
        self.send("remove_all_pending_#{container_names}".to_sym)
        containers.each do |container|
          self.send("append_pending_#{container_name}".to_sym, container)
        end
      })

      # published containments
      define_method(container_names.to_sym, lambda{
        container_class.joins("INNER JOIN containers ON containers.container_id=#{container_names}.id").where(["containers.item_id=? AND containers.item_type=? AND containers.container_type=? AND containers.pending=?", self.id, self.class.name, container_class.name, false])
      })

      define_method("publish_#{container_names}!".to_sym, lambda{
        Container.where(:item_id => self.id, :item_type => self.class.name, :container_type => container_class.name, :pending => false).delete_all
        self.send("pending_#{container_names}".to_sym).each do |container|
          Container.create(:item_id => self.id, :item_type => self.class.name, :container_id => container.id, :container_type => container.class.name, :pending => false)
        end
      })

      define_method(:after_publish, lambda{
        self.send("publish_#{container_names}!".to_sym)
        super()
      })
    end
  end

  #
  # Instance Methods.
  #
end
