require_relative 'api_factory'

module Sinatra
  module RestfulApi
    class DefaultConditionsParser
      def self.parse(conditions, model)
        conditions.empty? ? :all : conditions
      end
    end

    module Helpers
      def restful_api_for(name)
        ApiFactory.new(name, settings).build_restful_api!
      end

      def read_conditions(resource)
        conditions = params.except('include')
        conditions_parser.parse(conditions, resource)
      end

      def conditions_parser
        setting_or_default(:restful_api_conditions_parser, DefaultConditionsParser)
      end

      def setting_or_default(setting, default)
        settings.respond_to?(setting) ? settings.send(setting) : default
      end
    end
  end
end