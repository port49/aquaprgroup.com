class HomePagesController < ApplicationController

  def get
    @resource = Page.where(:name => "Home Page").first
    @gallery_resources = MrssFeed.by_category(/Observation|Artwork/).collect(&:images).flatten.sort{|a,b| b.date <=> a.date}[0,8]
    @featured_images_resources = MrssFeed.by_project.collect(&:images).flatten
    @ipac_news = NewsItem.visible
    @project_mrss_news_resources = MrssNewsFeed.by_category(/Press Release|Feature/).collect(&:images).flatten.sort{|a,b| b.date <=> a.date}[0,8]
    @project_rss_news_resources = RssNewsFeed.local.sort{|a,b| b.date <=> a.date}[0,10]
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
