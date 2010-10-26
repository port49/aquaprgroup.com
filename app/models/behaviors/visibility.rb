# Display class (based on convenient_dictionary plugin) is implied in this system.
module Visibility
  # Bootstrap the class methods.
  def self.included( klass )
    klass.extend ClassMethods
    klass.named_scope :visible, :conditions => { :workflow_id => Workflow.published.to_i, :display_id => Display.visible.to_i }
  end
  
#
# Class Methods.
#
  module ClassMethods
  end

#
# Instance Methods.
#
  def display
    Display.fetch( self.display_id )
  end

  def display=( display_instance )
    case display_instance.class.name
    when "Display"
      self.display_id = display_instance.id
    when "Fixnum"
      self.display_id = display_instance
    end
  end
  
  def is_visible?
    self.display == Display.visible
  end
  
end
