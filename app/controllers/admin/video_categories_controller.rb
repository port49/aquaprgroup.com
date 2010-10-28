class Admin::VideoCategoriesController < Admin::ExtishController

protected
  def after_update
    @items = Video.unscoped.find(params[:contained_items]) rescue []
    @resource.set_pending_videos @items
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    VideoCategory
  end

  def resource_singular_path(resource)
    admin_video_category_path(resource)
  end

  def resource_plural_path
    admin_video_categories_path
  end
end
