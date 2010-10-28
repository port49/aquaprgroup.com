class Admin::PackagesController < Admin::ExtishController

protected
  def after_update
    # combined the contained items and set them
    @items = []
    params[:contained_items].each do |item|
      item_id, item_type = item.split('.')
      @items << item_type.classify.constantize.unscoped.find(item_id) rescue nil
    end if params[:contained_items]
    @resource.set_pending_items @items.compact
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    Package
  end

  def resource_singular_path(resource)
    admin_package_path(resource)
  end

  def resource_plural_path
    admin_packages_path
  end
end
