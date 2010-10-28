class VideoCategory < ActiveRecord::Base
  include Pendable
  include Containable

  contains :videos
end
