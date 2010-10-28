class Admin::AvmImagesController < Admin::ExtishController

protected
  def after_update
    @packages = Package.find(params[:packages]) rescue []
    @resource.set_pending_packages @packages
    SecondaryFile.destroy(params[:deleted_secondary_files]) if params[:deleted_secondary_files]
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    AvmImage
  end

  def resource_singular_path(resource)
    admin_avm_image_path(resource)
  end

  def resource_plural_path
    admin_avm_images_path
  end
end
