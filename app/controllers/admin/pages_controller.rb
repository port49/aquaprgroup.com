class Admin::PagesController < Admin::ExtishController

protected
  def parse_search
    @conditions = false
  end

  def resource_class
    Page
  end

  def resource_singular_path(resource)
    admin_page_path(resource)
  end

  def resource_plural_path
    admin_pages_path
  end

  def before_update
    params[:page][:links] ||= []
  end
end
