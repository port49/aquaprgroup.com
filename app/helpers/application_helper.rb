module ApplicationHelper
  def date_format(datetime)
    datetime.strftime("%m/%d/%y") unless datetime.nil?
  end

  def youtube_token(url)
    url.match(/youtube.com\/watch\?v=([^&.]+)/)[1]
  end

  def youtube_embed(url)
    "http://www.youtube.com/v/#{youtube_token(url)}?fs=1&amp;hl=en_US"
  end
end
