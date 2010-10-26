class Admin::MediaFilesController < Admin::ExtishController

protected
  def resource_class
    MediaFile
  end

  def resource_singular_path(resource)
    admin_media_file_path(resource)
  end

  def resource_plural_path
    admin_media_files_path
  end
end
