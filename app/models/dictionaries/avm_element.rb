class AvmElement < Dictionary
  populate [
    {:tag_name => 'Creator', :schema => 'photoshop:Source', :data_type => :text, :avm_group_id => 1},
    {:tag_name => 'CreatorURL', :schema => 'Iptc4xmpCore:CiUrlWork', :data_type => :iptc_contact, :exif_shorthand => 'CreatorWorkURL', :avm_group_id => 1},
    {:tag_name => 'Contact.Name', :schema => 'dc:creator', :data_type => :sequence, :avm_group_id => 1},
    {:tag_name => 'Contact.Email', :schema => 'Iptc4xmpCore:CiEmailWork', :data_type => :iptc_contact, :exif_shorthand => 'CreatorWorkEmail', :avm_group_id => 1},
    {:tag_name => 'Contact.Telephone', :schema => 'Iptc4xmpCore:CiTelWork', :data_type => :iptc_contact, :exif_shorthand => 'CreatorWorkTelephone', :avm_group_id => 1},
    {:tag_name => 'Contact.Address', :schema => 'Iptc4xmpCore:CiAdrExtadr', :data_type => :iptc_contact, :exif_shorthand => 'CreatorAddress', :avm_group_id => 1},
    {:tag_name => 'Contact.City', :schema => 'Iptc4xmpCore:CiAdrCity', :data_type => :iptc_contact, :exif_shorthand => 'CreatorCity', :avm_group_id => 1},
    {:tag_name => 'Contact.StateProvince', :schema => 'Iptc4xmpCore:CiAdrRegion', :data_type => :iptc_contact, :exif_shorthand => 'CreatorRegion', :avm_group_id => 1},
    {:tag_name => 'Contact.PostalCode', :schema => 'Iptc4xmpCore:CiAdrPcode', :data_type => :iptc_contact, :exif_shorthand => 'CreatorPostalCode', :avm_group_id => 1},
    {:tag_name => 'Contact.Country', :schema => 'Iptc4xmpCore:CiAdrCtry', :data_type => :iptc_contact, :exif_shorthand => 'CreatorCountry', :avm_group_id => 1},
    {:tag_name => 'Rights', :schema => 'xapRights:UsageTerms', :data_type => :alternatives, :avm_group_id => 1, :input_type => :textarea},
    {:tag_name => 'Title', :schema => 'dc:title', :data_type => :alternatives, :avm_group_id => 2},
    {:tag_name => 'Headline', :schema => 'photoshop:Headline', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Description', :schema => 'dc:description', :data_type => :alternatives, :avm_group_id => 2},
    {:tag_name => 'Subject.Category', :schema => 'avm:Subject.Category', :data_type => :bag, :avm_group_id => 2},
    {:tag_name => 'Subject.Name', :schema => 'dc:subject', :data_type => :bag, :avm_group_id => 2},
    {:tag_name => 'Distance', :schema => 'avm:Distance', :data_type => :sequence, :avm_group_id => 2},
    {:tag_name => 'Distance.Notes', :schema => 'avm:Distance.Notes', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'ReferenceURL', :schema => 'avm:ReferenceURL', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Credit', :schema => 'photoshop:Credit', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Date', :schema => 'photoshop:DateCreated', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'ID', :schema => 'avm:ID', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Type', :schema => 'avm:Type', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Image.ProductQuality', :schema => 'avm:Image.ProductQuality', :data_type => :text, :avm_group_id => 2},
    {:tag_name => 'Facility', :schema => 'avm:Facility', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Instrument', :schema => 'avm:Instrument', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spectral.ColorAssignment', :schema => 'avm:Spectral.ColorAssignment', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spectral.Band', :schema => 'avm:Spectral.Band', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spectral.Bandpass', :schema => 'avm:Spectral.Bandpass', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spectral.CentralWavelength', :schema => 'avm:Spectral.CentralWavelength', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spectral.Notes', :schema => 'avm:Spectral.Notes', :data_type => :alternatives, :avm_group_id => 3},
    {:tag_name => 'Temporal.StartTime', :schema => 'avm:Temporal.StartTime', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Temporal.IntegrationTime', :schema => 'avm:Temporal.IntegrationTime', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'DatasetID', :schema => 'avm:DatasetID', :data_type => :sequence, :avm_group_id => 3},
    {:tag_name => 'Spatial.CoordinateFrame', :schema => 'avm:Spatial.CoordinateFrame', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Spatial.Equinox', :schema => 'avm:Spatial.Equinox', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Spatial.ReferenceValue', :schema => 'avm:Spatial.ReferenceValue', :data_type => :sequence, :avm_group_id => 4},
    {:tag_name => 'Spatial.ReferenceDimension', :schema => 'avm:Spatial.ReferenceDimension', :data_type => :sequence, :avm_group_id => 4},
    {:tag_name => 'Spatial.ReferencePixel', :schema => 'avm:Spatial.ReferencePixel', :data_type => :sequence, :avm_group_id => 4},
    {:tag_name => 'Spatial.Scale', :schema => 'avm:Spatial.Scale', :data_type => :sequence, :avm_group_id => 4},
    {:tag_name => 'Spatial.Rotation', :schema => 'avm:Spatial.Rotation', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Spatial.CoordsystemProjection', :schema => 'avm:Spatial.CoordsystemProjection', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Spatial.Quality', :schema => 'avm:Spatial.Quality', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Spatial.Notes', :schema => 'avm:Spatial.Notes', :data_type => :alternatives, :avm_group_id => 4},
    {:tag_name => 'Spatial.FITSheader', :schema => 'avm:Spatial.FITSheader', :data_type => :text, :avm_group_id => 4},
    {:tag_name => 'Publisher', :schema => 'avm:Publisher', :data_type => :text, :avm_group_id => 5},
    {:tag_name => 'PublisherID', :schema => 'avm:PublisherID', :data_type => :text, :avm_group_id => 5},
    {:tag_name => 'ResourceID', :schema => 'avm:ResourceID', :data_type => :text, :avm_group_id => 5},
    {:tag_name => 'ResourceURL', :schema => 'avm:ResourceURL', :data_type => :text, :avm_group_id => 5},
    {:tag_name => 'RelatedResources', :schema => 'avm:RelatedResources', :data_type => :bag, :avm_group_id => 5},
    {:tag_name => 'MetadataDate', :schema => 'avm:MetadataDate', :data_type => :text, :avm_group_id => 5},
    {:tag_name => 'MetadataVersion', :schema => 'avm:MetadataVersion', :data_type => :text, :avm_group_id => 5}
  ] 

  def self.find_by_tag_name(tag_name)
    self.all.detect{|a| a.tag_name == tag_name}
  end

  def avm_group
    AvmGroup.find(avm_group_id)
  end
  
  # because caps and punctuation don't belong as keys in form arrays
  def name
    self.tag_name.gsub('.','_').downcase
  end
end

