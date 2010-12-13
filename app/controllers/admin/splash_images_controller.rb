class Admin::SplashImagesController < Admin::ExtishController

protected
  def after_update
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    SplashImage
  end

  def resource_singular_path(resource)
    admin_splash_image_path(resource)
  end

  def resource_plural_path
    admin_splash_images_path
  end
end
