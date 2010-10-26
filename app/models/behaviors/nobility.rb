# This is enhanced to work with revisionality.  Bootstrap the class with something like:
#
#  def self.nobility
#    @@nobility ||= [
#      { :id => 1, :key => :home_page }
#    ]
#  end
#
# in the ActiveRecord model, where :id is the id of the published revision.  Make
# sure that this corresponds with a bootstrapped record.
#
module Nobility
  # Bootstrap the class methods.
  def self.included( klass )
    klass.extend ClassMethods
  end
  
#
# Class Methods.
#
  module ClassMethods
    
    def noble_records
      find nobility.collect{ |noble| noble[:id] }
    end
    
    # We want to quickly (painlessly) fetch a record via ._#{key}.
    def method_missing( name, *args)
      if species = name.to_s.match( /^_(\w+)/ )
        find nobility.detect{ |noble| noble[:key] == species[1].to_sym }[:id]
      else
        super
      end
    end
    
  end

#
# Instance Methods.
#
  
  def noble_key
    noble_match = self.class.nobility.detect{ |noble| noble[:id]  == self.id }
    noble_match ? noble_match[:key] : false
  end
  
  def is_a_noble?
    self.noble_key != false
  end
  
  # We want to quickly (painlessly) ask is_{key}?.
  def method_missing( name, *args)
    if species = name.to_s.match( /^is_(\w+)?/ )
      self.class.nobility.detect{ |noble| noble[:key] == species[1].to_sym && noble[:id]  == self.id }
    else
      super
    end
  end

end
