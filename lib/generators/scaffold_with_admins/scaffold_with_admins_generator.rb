require "rails/generators/named_base"

module Rails
  module Generators
    class ScaffoldGenerator < Rails::Generators::NamedBase
      def initialize(args, *options)
        generate "scaffold", "forums title:string description:text"
        # Copy view, test, controller to admin scope
        # Replace routes to admin_*
      end
    end
  end
end