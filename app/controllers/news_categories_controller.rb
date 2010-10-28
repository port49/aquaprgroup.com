class NewsCategoriesController < ApplicationController

  def get
    @news_category = NewsCategory.find(params[:id])
    @news_items = NewsCategory.find(params[:id]).news_items.find( :all, :order => "created_at DESC" )
    @page = Page.where(:name => "News Page").first
  end

end