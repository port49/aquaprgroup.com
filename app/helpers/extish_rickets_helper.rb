module ExtishRicketsHelper

  def singular_path(resource)
    resource_name = ActionController::RecordIdentifier.dom_class(resource)
    self.send("#{resource_name}_path".to_sym, {:id => resource})
  end

  def plural_path(resource, options={})
    resources_name = ActionController::RecordIdentifier.dom_class(resource).pluralize
    self.send("#{resources_name}_path".to_sym, options)
  end

  def admin_singular_path(resource)
    resource_name = ActionController::RecordIdentifier.dom_class(resource)
    if resource.new_record?
      self.send("admin_#{resource_name}_path".to_sym)
    else
      self.send("admin_#{resource_name}_path".to_sym, {:id => resource})
    end
  end

  def admin_plural_path(resource, options={})
    resources_name = ActionController::RecordIdentifier.dom_class(resource).pluralize
    self.send("admin_#{resources_name}_path".to_sym, options)
  end

  def ricket_tab(resource_class, options={})
    options[:name] ||= resource_class.name.pluralize
    options[:url] ||= self.send("admin_#{resource_class.table_name}_path", options[:params])
    options[:selected] ||= params[:controller] == "admin/#{resource_class.table_name}"
    raw("<li class='ui-state-default ui-corner-top ui-tab#{options[:selected] ? '-selected' : ''}'>#{link_to options[:name], options[:url]}</li>")
  end

  def rickets_header(name, printed_name)
    order_by_hash = {}
    params[:sort_order].split(';').each do |chunk|
      column, direction = chunk.split(':')
      order_by_hash[column] = direction 
    end if params[:sort_order]
    if order_by_hash.has_key? name 
      if order_by_hash[name] == 'down'
        order_by_hash[name] = 'up'
        css = "<span class='ui-icon ui-icon-carat-1-s float-left'></span>"
      else
        order_by_hash[name] = 'undefined'
        css = "<span class='ui-icon ui-icon-carat-1-n float-left'></span>"
      end
    else
      order_by_hash[name] = 'down'
    end
    order_by_hash.reject!{|k,v| v == 'undefined'}
    if order_by_hash.empty?
      adjusted_params = request.parameters.dup
      adjusted_params[:sort_order] = nil
    else
      sort_order_hash = {:sort_order => (order_by_hash.collect{|key, value| "#{ key }:#{ value }" } * ';')}
      adjusted_params = request.parameters.merge(sort_order_hash)
    end
    link_to raw("#{css}#{printed_name}"), url_for(adjusted_params)
  end

  def indented_option_tags
    javascript_tag(
<<-JS
$('option').each(function(index, option){
  text = $(option).text();
  $(option).html(text.replace(/----/g, '&nbsp;'));
});
JS
    )
  end

  def plus_or_minus_fields(avm_data, name)
    html = ""
    (avm_data[name] || []).each do |avm_data_minus|
      unless avm_data_minus == avm_data[name].first
        html << "<div class='field'>"
        html << "<label>&nbsp;</label>"
        html << text_field_tag("avm_image[pending_avm_data][#{name}][]", avm_data_minus, :class => 'string minus')
        html << "</div>"
      end
    end
    raw html
  end
end
