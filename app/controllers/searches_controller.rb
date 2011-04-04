class SearchesController < ApplicationController

  def get
    @pages      = Page.search(params[:q])
    @news_items = NewsItem.search(params[:q])
  end

protected
end
