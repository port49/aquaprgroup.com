class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  before_filter :prepare_restful_resource

  # All methods return a status code of 405 by default, which is "Method not allowed." This
  # requires that all actions be explicitly defined in the controllers, which is better for
  # security, even if it is as simple as 'def gets; end'
  [ :gets, :posts, :puts, :deletes, :get, :post, :put, :delete ].each do |action|
    define_method action do
      respond_to do |format|
        response_body =<<-HTML
          <html>
            <body>
              <h1>405: Method not allowed.</h1>
              <p>#{action.to_s.capitalize} called from '#{self.class.name}' 
                with: #{self.instance_variables.inspect}</p>
              <p>You must explicitly define this action in your controller if you wish to use it.</p>
            </body>
          </html>
        HTML
        format.html {render :text => response_body, :status => 405}
      end
    end
  end

protected

  def prepare_restful_resource
    if self.respond_to? :resource_class
      # plural
      if %w(gets posts puts deletes).include? self.action_name
        parse_search
        parse_sort_order
        @resources = resource_class.where(@conditions).order(@order).paginate :page => params[:page], :per_page => per_page
      # singular
      elsif %w(get post put delete).include? self.action_name
        if params[:id].to_i == 0
          @resource = resource_class.new
        else
          @resource = resource_class.find(params[:id]) if params[:id]
        end
      end
    end
  end

  # overwrite in child classes
  def parse_search; end
  def parse_sort_order; end
  def per_page; end
  
end
