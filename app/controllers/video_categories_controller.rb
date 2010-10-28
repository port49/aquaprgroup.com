class VideoCategoriesController < ApplicationController

  def get
    @video_category = VideoCategory.find(params[:id])
    @video_items = VideoCategory.find(params[:id]).videos.find( :all, :order => "created_at DESC" )
    @page = Page.where(:name => "Video Page").first
  end

end