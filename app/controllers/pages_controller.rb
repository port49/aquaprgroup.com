class PagesController < ApplicationController

  def get
    @page = Page.find(params[:id])
  end

protected
  def resource_class
    Page
  end

  def resource_singular_path(resource)
    page_path(resource)
  end

  def resource_plural_path
    pages_path
  end
end
