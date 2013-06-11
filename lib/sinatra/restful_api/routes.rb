require_relative 'api_factory'
require_relative 'routes/custom_routes'
require_relative 'routes/restful_routes'

module Sinatra
  module RestfulApi
    module Routes
      def self.draw(model_name, app, &block)
        api = ApiFactory.new(model_name, app.settings).build_restful_api!

        RestfulRoutes.new(model_name, app, api).build!
        CustomRoutes.new(model_name, app, api).build!(&block)
      end
    end
  end
end