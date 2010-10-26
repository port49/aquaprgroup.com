class NewsItemsController < ApplicationController

  def get
    @resource = Page.where(:name => "Home Page").first
    @news = NewsItem.find(params[:id])
  end

  def gets
    @resource = Page.where(:name => "News").first
    @ipac_news = NewsItem.visible
  end

protected
  def resource_class
    NewsItem
  end

  def resource_singular_path(resource)
    news_item_path(resource)
  end

  def resource_plural_path
    news_items_path
  end
end
