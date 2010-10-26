require 'rails/generators/named_base'

module Authlogic
  module Generators
    class Base < Rails::Generators::NamedBase
      def self.source_root
        @_extish_rickets_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'extish_rickets', generator_name, 'templates'))
      end
    end
  end
end
