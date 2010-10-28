class VideosController < ApplicationController

  def get
    @page = Page.where(:name => "Video Page").first

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def gets
    @page = Page.where(:name => "Video Page").first
  end

protected
  def resource_class
    Video
  end

  def per_page
    5
  end 

end
