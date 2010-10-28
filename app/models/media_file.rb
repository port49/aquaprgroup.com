class MediaFile < ActiveRecord::Base
  has_attached_file :binary, :styles => {
    :icon=> "21x21#",
    :thumb=> "100x100#"
  }
end
