class Admin::VideosController < Admin::ExtishController

protected
  def after_update
    @video_categories = VideoCategory.find(params[:video_categories]) rescue []
    @resource.set_pending_video_categories @video_categories
    @packages = Package.find(params[:packages]) rescue []
    @resource.set_pending_packages @packages
    SecondaryFile.destroy(params[:deleted_secondary_files]) if params[:deleted_secondary_files]
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    Video
  end

  def resource_singular_path(resource)
    admin_video_path(resource)
  end

  def resource_plural_path
    admin_videos_path
  end
end
