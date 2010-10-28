class AvmValue < ActiveRecord::Base
  belongs_to :avm_image
  
  def self.find_by_category(category)

    if category == "Observations"
      avm_category_lookup = "Observation"
      lookup = "type"
    elsif category == "Artist Concepts"
      avm_category_lookup = "Artwork"
      lookup = "type"
    elsif category == "Photos"
      avm_category_lookup = "Photographs"
      lookup = "type"
    elsif category == "Spectra"
      avm_category_lookup = "Chart"
      lookup = "type"
    elsif category == "Observatory"
      avm_category_lookup = "_.8.1.2%"
      lookup = "subject"
    elsif category == "Logos"
      avm_category_lookup = "_.10.1%"
      lookup = "subject"
    else
      avm_category_lookup = "Observation"
      lookup = "type"
    end
    
    if lookup == "type"
      AvmValue.where(:avm_element_id => 23, :value => avm_category_lookup)
    elsif lookup == "subject" 
      AvmValue.where(["avm_element_id=? AND value LIKE '#{avm_category_lookup}'", 15])
    end

  end
end