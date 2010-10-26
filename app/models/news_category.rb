class NewsCategory < ActiveRecord::Base
  include Pendable
  include Containable

  contains :news_items
end
