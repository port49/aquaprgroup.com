class HomePagesController < ApplicationController

  def get
    @resource = Page.where(:name => "Home Page").first
    @splashpanes = SplashImage.all
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
