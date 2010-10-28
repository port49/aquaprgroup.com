class AvmImagesController < ApplicationController

  def gets
    @page = Page.where(:name => "Image Page").first
    @avm_categories = ["Observations", "Spectra", "Artist Concepts", "Photos", "Observatory", "Logos" ]
    if params[:avm_category]
      @avm_category = params[:avm_category]
      @avm_values = AvmValue.find_by_category(@avm_category)
      @resources = @avm_values.collect{|av| av.avm_image}.compact.paginate :page => params[:page], :per_page => per_page
    end
  end

  def get
    @page = Page.where(:name => "Image Page").first
    @avm_categories = ["Observations", "Spectra", "Artist Concepts", "Photos", "Observatory", "Logos" ]
  end

protected
  def resource_class
    AvmImage
  end

  def resource_singular_path(resource)
    avm_image_path(resource)
  end

  def resource_plural_path
    avm_images_path
  end

  def per_page
    5
  end 

end
