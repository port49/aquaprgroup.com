# Provides a universal dictionary that operates in an AR-ish fashion.
class Dictionary < OpenStruct

  def self.inherited(subclass)
  end
  
  # Bootstrap the class and instance methods.
  def self.populate(entries)
    data = []
    entries.each_with_index do |entry, i| 
      data << self.new(entry.merge({:id => i + 1}))
    end
    class_variable_set(:@@data, data)
  end
  
  def self.all
    class_variable_get(:@@data)
  end
    
  def self.find(what)
    case(what.class.name)
    when "NilClass"
      raise "#{self.to_s} error: Cannot fetch #{self.to_s.downcase} looking for a Nil object."
    when "Symbol"
      case(what)
      when :all
        self.all
      when :first
        self.all[0]
      else
        raise "#{self.to_s} error: Fetch symbol misunderstood."
      end
    when "Fixnum"
      self.all.detect{|e| e.id == what}
    when "String"
      self.all.detect{|e| (e.name == what) || (e.name.gsub(" ", "_").downcase == what.gsub(" ", "_").downcase)}
    else
      raise "#{self.to_s} error: What type of #{self.to_s.downcase} is that?"
    end
  end

  # select_tag() helper
  def self.options
    self.all.collect{|e| [e.name, e.id]}
  end

  # We want to quickly (painlessly) fetch a record via .#{name} as
  # long as there's no method collision.
  def self.method_missing(name, *args)
    if species = name.to_s.match( /\w+/ ) and record = self.find(species[0])
      record
    else
      super
    end
  end
    
  #
  # Instance Methods.
  #
  def initialize(attributes)
    # attr assignment from OpenStruct
    super
  end
  
  def ===(other)
    self == other
  end

  def to_i
    self.id
  end
  
  # We want to quickly (painlessly) ask .is_#{name}?
  def method_missing(name, *args)
    if species = name.to_s.match( /^is_(\w+)?/ )
      self.name.gsub( " ", "_" ).downcase == species[1]
    else
      super
    end
  end

end
  
