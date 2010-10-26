class GalleryPagesController < ApplicationController

  def gets
    @resource = Page.where(:name => "Gallery").first
    @gallery_resources = MrssFeed.by_category(/Observation|Artwork/).collect(&:images).flatten.sort{|a,b| b.date <=> a.date}[0,20]
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
