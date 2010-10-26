require 'generators/extish_rickets'

module ExtishRickets
  module Generators
    class ScaffoldGenerator < Base
      extend TemplatePath

      desc "Builds an Extish scaffold."
      
      check_class_collision
      
      def create_session_file
        template 'session.rb', File.join('app', 'models', class_path, "#{file_name}.rb")
      end
      
      hook_for :test_framework
 
      def copy_layout_file
        return unless options[:layout]
        template "layout.haml.erb",
                 File.join("app/views/layouts", controller_class_path, "#{controller_file_name}.html.haml")
      end

      protected

      def copy_view(view)
        template "#{view}.haml.erb", File.join("app/views", controller_file_path, "#{view}.html.haml")
      end

    end
  end
end

