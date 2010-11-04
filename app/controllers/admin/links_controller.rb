class Admin::LinksController < Admin::ExtishController

protected
  def after_update
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    Link
  end

  def resource_singular_path(resource)
    admin_link_path(resource)
  end

  def resource_plural_path
    admin_links_path
  end
end
