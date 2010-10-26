# Just filter the records based on whether 'visible' is set to true.
module Visible
  # Bootstrap the class methods.
  def self.included(klass)
    klass.extend ClassMethods

    klass.send(:default_scope, klass.where(["visible=? OR visible=?", true, false]))
    klass.scope :include_invisible, klass.where(["visible=? OR visible=?", true, false])
    klass.scope :visible, klass.where(:visible => true)
    klass.scope :invisible, klass.where(:visible => false)
  end
  
  #
  # Class Methods.
  #
  module ClassMethods
  end

  #
  # Instance Methods.
  #
  def is_visible?
    self.visible?
  end
end
