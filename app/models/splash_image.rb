class SplashImage < ActiveRecord::Base
  has_attached_file :binary, :styles => {
    :icon=> "21x21#",
    :thumb=> "100x100#",
    :large => "698x320"
  }
end
