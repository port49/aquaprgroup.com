require 'open3'
require 'rexml/document'

# when we first create an AvmImage, if there is a file attached, we read in
# the data from the file and store it in the db; forever after, on any save,
# we push the data from the db to the file; on publish, we copy the pending
# data over to the db and push it to the file 
class AvmImage < ActiveRecord::Base
  include Pendable
  include Visible
  include Containable

  contained_by :packages

  attr_accessor :pending_avm_data

  has_many :avm_values
  has_many :secondary_files, :as => :primary_file, :conditions => {:pending => false}, :dependent => :destroy
  has_many :pending_secondary_files, :as => :primary_file, :conditions => {:pending => true}, :class_name => 'SecondaryFile', :dependent => :destroy
  attr_accessor :pending_secondary_files_attr

  has_attached_file :binary, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"
  has_attached_file :image, :styles => {
    :icon   => "21x21#",
    :thumb  => "155x155#",
    :medium => "250x250#"
  }, :url => "/system/#{self.table_name}/:attachment/:id/:style/:filename"

  # this gets called on create as well as on updates
  def before_update_pending(attrs)
    self.update_attributes(:binary => attrs['binary']) if attrs['binary']
    self.update_attributes(:image => attrs['image']) if attrs['image']

    # create all pending secondary files
    if attrs[:pending_secondary_files_attr]
      attrs[:pending_secondary_files_attr].each do |secondary_file|
        s = SecondaryFile.create(secondary_file.merge(:pending => true, :primary_file_id => self.id, :primary_file_type => self.class.name))
      end
    end

    self.update_pending_if_first_upload(attrs)
    super
  end

  def before_publish
    # we need to force load pending because pending_avm_data needs to be in place
    load_pending
    # set some of the read-only values
    self.pending_avm_data[:referenceurl] = "#{AVM_URL}/avm_image/#{self.id}"
    self.pending_avm_data[:resourceid]   = "#{self.binary_file_name}"
    self.pending_avm_data[:resourceurl]  = "#{AVM_URL}#{self.binary.try(:url)}"
    self.pending_avm_data[:metadatadate] = "#{Date.today.try(:strftime, '%Y-%m-%d')}"
    self.pending_avm_data[:date]         = self.release_date.try(:strftime, '%Y-%m-%d')
    # propagate the data from pending_avm_data to the published model
    self.avm_data = self.pending_avm_data.stringify_keys unless self.pending_avm_data.nil?
  end

  def after_publish
    # write the new AVM data to the file if it exists
    if self.binary.path && File.exists?(self.binary.path)
      self.reload.avm_values
      AvmImage.write_xmp_to_file(self.binary.path, self.avm_data)
    end

    # remove the published secondary files
    self.reload.secondary_files.clear
    # make the pending secondary files published
    self.pending_secondary_files.each do |secondary_file|
      secondary_file.update_attributes(:pending => false)
      secondary_file_avm_data = self.avm_data.merge(
        'resourceid' => secondary_file.binary_file_name, 
        'resourceurl' => "#{AVM_URL}#{secondary_file.binary.try(:url)}"
      )
      AvmImage.write_xmp_to_file(secondary_file.binary.path, secondary_file_avm_data)
      # make a new pending copy of the newly published file
      secondary_file.make_pending_clone!
    end
  end

  def load_pending
    # the pending avm data is stored differently, but we don't actually
    # want to overwrite the associated avm_data, so we just link to it if
    # we are looking at the pending version of a record
    super
#    if self.is_pending?
#      def self.avm_data; self.pending_avm_data || {}; end
#    end
  end

  # read and write AVM data using XMP
  def self.read_xmp_from_file(filename)
    raise "Cannot find file for XMP extraction." unless File.file?(filename)
    stdin, stdout, stderr = Open3.popen3 "exiftool -b -xmp #{filename}"
    @xmp_doc = Nokogiri::XML stdout.read
    @data = {}
    namespaces = {
      'rdf'          => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      'exif'         => "http://ns.adobe.com/exif/1.0/",
      'tiff'         => "http://ns.adobe.com/tiff/1.0/",
      'xap'          => "http://ns.adobe.com/xap/1.0/",
      'xapMM'        => "http://ns.adobe.com/xap/1.0/mm/",
      'stRef'        => "http://ns.adobe.com/xap/1.0/sType/ResourceRef#",
      'dc'           => "http://purl.org/dc/elements/1.1/",
      'photoshop'    => "http://ns.adobe.com/photoshop/1.0/",
      'avm'          => "http://www.communicatingastronomy.org/avm/1.0/",
      'crs'          => "http://ns.adobe.com/camera-raw-settings/1.0/",
      'illustrator'  => "http://ns.adobe.com/illustrator/1.0/",
      'Iptc4xmpCore' => "http://iptc.org/std/Iptc4xmpCore/1.0/xmlns/",
      'xapRights'    => "http://ns.adobe.com/xap/1.0/rights/"
    }
    AvmElement.all.each do |avm|
      case avm.data_type
      when :text
        @data[avm.name] = try_value @xmp_doc.xpath("//rdf:RDF/rdf:Description/#{avm.schema}", namespaces)
      when :iptc_contact
        @data[avm.name] = try_value @xmp_doc.xpath("//rdf:RDF/rdf:Description//#{avm.schema}", namespaces)
      when :sequence
        items = @xmp_doc.xpath("//rdf:RDF/rdf:Description/#{avm.schema}/rdf:Seq/rdf:li", namespaces)
        @data[avm.name] = items.empty? ? nil : items.collect{|li| try_value(li) }
      when :bag
        items = @xmp_doc.xpath("//rdf:RDF/rdf:Description/#{avm.schema}/rdf:Bag/rdf:li", namespaces)
        @data[avm.name] = items.empty? ? nil : items.collect{|li| try_value(li) }
      when :alternatives
        items = @xmp_doc.xpath("//rdf:RDF/rdf:Description/#{avm.schema}/rdf:Alt/rdf:li", namespaces)
        # We only take the first Alt.  We do not handle other languages.
        @data[avm.name] = items.empty? ? nil : try_value(items[0])
      end
    end
    return @data
  end

  def self.clear_xmp_from_file(filename)
    `exiftool -xmp:All= #{filename}`
  end

  def self.write_xmp_to_file(filename, data)
    raise "Cannot find file for XMP writing." unless File.file?(filename)
    exiftool_temporary_filename = filename + '_exiftool_tmp'
    exiftool_original_filename = filename + '_original'
    @parameters = ""
    data.each do |avm_name, value|
      if ((avm = AvmElement.find(avm_name)) && !value.nil? && (value != "undefined")) 
        case avm.data_type
        when :text
          @parameters += " -xmp-#{avm.schema}=\"#{escape_for_exiftool(value)}\""
        when :alternatives
          @parameters += " -xmp-#{avm.schema}=\"#{escape_for_exiftool(value)}\""
        when :sequence, :bag
          @parameters += value.collect{|v| " -xmp-#{avm.schema}+=\"#{escape_for_exiftool(v)}\""} * ""
        when :iptc_contact
          @parameters += " -xmp-iptcCore:#{avm.exif_shorthand}=\"#{escape_for_exiftool(value)}\""
        end
      end
    end
    # No blocking, please.
    File.delete exiftool_temporary_filename if File.exists?(exiftool_temporary_filename)
    # clear all data first, because bugs and stuff
    `exiftool -all= #{filename}`
    # Make a run for it.
    stdin, stdout, stderr = Open3.popen3 "exiftool#{@parameters} #{filename}"
    # Like a ninja, we leave no trace.
    File.delete exiftool_original_filename if File.exists?(exiftool_original_filename)
    
    return stdout.readlines.include?("    1 image files updated\n")
  end

  def self.try_value(xml_node)
    value = xml_node.try(:text).encode("ASCII", :invalid => :replace, :undef => :replace, :replace => '')
    value = nil if value.length == 0
    value
  end

  def self.escape_for_exiftool(text)
    text.gsub('"', '\\"')
  end

  def pending_avm_data
    @pending_avm_data || avm_data
  end

  def avm_data
    @data = {}
    AvmElement.all.each do |avm_element|
      case avm_element.data_type
      when :text, :alternatives, :iptc_contact
        value = self.avm_values.detect{|v| v.avm_element_id == avm_element.id}.try(:value)
      when :sequence, :bag
        value = self.avm_values.select{|v| v.avm_element_id == avm_element.id}.sort{|a,b| a.position <=> b.position}.collect(&:value)
      end
      if (value && !value.empty?)
        @data[avm_element.name] = value
      else
        @data[avm_element.name] = nil
      end
    end
    return @data
  end

  def avm_data=(data)
    transaction do
      # Clear all data.
      self.avm_values.delete_all
      AvmElement.all.each do |avm_element|
        case avm_element.data_type
        when :text, :alternatives, :iptc_contact
          self.avm_values.create(:value => data[avm_element.name], :avm_element_id => avm_element.id)
        when :sequence, :bag
          data[avm_element.name].each_with_index do |value, i|
            self.avm_values.create(:value => value, :avm_element_id => avm_element.id, :position => i)
          end if data[avm_element.name]
        end
      end
    end
  end

protected
  def update_pending_if_first_upload(attrs)
    # if a binary was just uploaded, import it's data into pending_avm_data
    pending_attributes = self.try(:pending).try(:serialized_attributes) || {}
    if !pending_attributes[:pending_avm_data] && attrs[:binary] && self.binary.path && File.exists?(self.binary.path)
      attrs[:pending_avm_data] = AvmImage.read_xmp_from_file(self.binary.path).stringify_keys

      # prepopulate these fields
      [[:catalog_id, 'id'], [:name, 'title'], [:abstract, 'headline'], [:image_credit, 'credit']].each do |key|
        attrs[key[0]] = attrs[:pending_avm_data][key[1]] if (attrs[key[0]].nil? || attrs[key[0]].empty?)
      end
      attrs[:release_date] = Date.parse(attrs[:pending_avm_data]['date']) if ((attrs[:release_date].nil? || attrs[:release_date].empty?) && (attrs[:pending_avm_data]['date']))
      attrs[:body] = (attrs[:pending_avm_data]['description'] || "").split(/\n\n/).collect{|p| "<p>#{p}</p>"}.join("") if (attrs[:body].nil? || attrs[:body].empty?)
    end
  end
end
