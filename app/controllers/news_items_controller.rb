class NewsItemsController < ApplicationController

  def get
    @page = Page.where(:name => "News Page").first

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def gets
    @page = Page.where(:name => "News Page").first
  end
  
protected

  def parse_sort_order
    @order = "Release_Date DESC"
  end

  def resource_class
    NewsItem
  end
  
  def per_page
    5
  end 

end
