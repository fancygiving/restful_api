require_relative '../restful_api'
require_relative 'restful_api/helpers'
require_relative 'restful_api/route_builder'

module Sinatra
  module RestfulApi
    def self.registered(app)
      app.helpers Helpers
    end

    def restful_api(name)
      RouteBuilder.new(name, self).build_restful_routes!
    end
  end

  register RestfulApi
end
