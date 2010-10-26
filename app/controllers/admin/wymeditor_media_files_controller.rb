class Admin::WymeditorMediaFilesController < ApplicationController
  layout false

  # Plural methods.
  def gets
    respond_to do |format|
      format.html
    end
  end

protected
  def resource_class
    MediaFile
  end
end
