class WidgetsController < Admin::ExtishController

protected
  def resource_class
    Widget
  end

  def resource_singular_path(resource)
    widget_path(resource)
  end

  def resource_plural_path
    widgets_path
  end
end
