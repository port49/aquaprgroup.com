class NewsItemsController < ApplicationController

  def get
    respond_to do |format|
      format.html
    end
  end

  def gets
    respond_to do |format|
      format.html
    end
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
