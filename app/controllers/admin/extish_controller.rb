class Admin::ExtishController < ApplicationController
  layout 'extish_rickets'

  # Plural methods.
  def gets
    respond_to do |format|
      format.html
    end
  end

  # Singular methods.
  def get
    respond_to do |format|
      format.html
    end
  end

  def post
    respond_to do |format|
      before_update
      if @resource = resource_class.create(params[resource_symbol])
        after_update
        format.html{redirect_to(resource_singular_path(@resource), :notice => "#{@resource.name} created.")}
      else
        format.html{render :action => 'get'}
      end
    end
  end

  def put
    respond_to do |format|
      before_update
      if (@resource.respond_to?(:load_pending) && @resource.update_pending(params[resource_symbol])) || @resource.update_attributes(params[resource_symbol])
        after_update
        if params[:publish] == 'Publish'
          @resource.publish!
        end
        format.html{redirect_to(resource_singular_path(@resource), :notice => "#{@resource.name} updated.")}
      else
        format.html{render :action => 'get'}
      end
    end
  end

  def delete
    @resource.destroy

    respond_to do |format|
      format.html{redirect_to(resource_plural_path, :notice => "#{@resource.name} deleted.")}
    end
  end

protected

  def prepare_restful_resource
    super
    @resource.load_pending if @resource && @resource.respond_to?(:load_pending)
    @resources = @resources.include_invisible if @resources.respond_to?(:visible)
    @resources.each(&:load_pending) if @resources && @resources.first.respond_to?(:load_pending)
    @new_resource = resource_class.new(:id => 0)
  end

  # Put search conditions in here.
  def parse_search
    return false unless params[:search]
    @conditions ||= []
    %w( name ).each do |column|
      @conditions << ActiveRecord::Base.send( :sanitize_sql_array, [ "LOWER(#{ column }) LIKE ?", "%%#{ params[:search] || "" }%%" ] )
    end
  end

  # Put 'order by' style conditions in here.
  def parse_sort_order
    return false unless params[:sort_order]
    order_by ||= []
    params[:sort_order].split( ';' ).each do |pair|
      column, direction = pair.split( ':' )
      order_by << "#{ column } #{ direction == 'up' ? 'DESC' : 'ASC' }"
    end
    @order = order_by * ", "
  end

  # Put filtering conditions in here, for enumerated column data.
  def parse_filter
    @conditions ||= []
    %w( name ).each do |column|
      param_key = ( column + "_filter" ).to_sym
      if params[ param_key ] && params[ param_key ].length > 0 
        field = field_of_interest( column )
        @conditions << ActiveRecord::Base.send( :sanitize_sql_array, [ "LOWER(#{ column.pluralize }.#{ field }) LIKE ?", '%' + params[ param_key ].clean_query_string + '%' ] ) if ( !field.nil? && params[ param_key ].clean_query_string.length > 0 )
      end
    end
  end

  def resource_symbol
    resource_class.name.underscore.to_sym
  end

  def per_page
    24
  end

  def before_update; end
  def after_update; end
end
