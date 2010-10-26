# Generate pretty urls for these models.
module PrettyUrlity
  # Bootstrap the class methods.
  def self.included( klass )
    klass.extend ClassMethods
  end
  
#
# Class Methods.
#
  module ClassMethods
  end

#
# Instance Methods.
#
  def to_param
    if self.has_attribute?( :sscid ) && self.sscid && !self.sscid.empty?
      "#{ self.id }-#{ self.sscid }-#{ ( self.send( self.class.name_field ) || "" ).gsub( /[^a-z0-9]+/i, '-' ) }"
    else
      "#{ self.id }-#{ ( self.send( self.class.name_field ) || "" ).gsub( /[^a-z0-9]+/i, '-' ) }"
    end
  end

end
