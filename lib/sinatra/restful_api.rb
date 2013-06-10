require_relative '../restful_api'
require_relative 'restful_api/helpers'
require_relative 'restful_api/route_builder'

module Sinatra
  module RestfulApi
    def self.registered(app)
      app.helpers Helpers
    end

    def restful_api(name)
      helpers do
        define_method("#{name}_api") do
          instance_variable_get("@#{name}_api") ||
            instance_variable_set("@#{name}_api", restful_api_for(name))
        end
      end

      RouteBuilder.new(name, self).build_restful_routes!






    end
  end

  register RestfulApi
end
