# Methods added to this helper will be available to all templates in the application.
module WymeditorMediaFilesHelper

  def wymeditor_image_insert_link(resource)
    javascript = "$('input.wym_src').val('#{resource.binary.url}');$('input.wym_alt').val('#{escape_javascript(resource.name)}');$('input.wym_title').val('#{escape_javascript(resource.name)}');$('input.wym_submit').trigger('click');"
  end

end
