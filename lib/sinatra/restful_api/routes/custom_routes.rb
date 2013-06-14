module Sinatra
  module RestfulApi
    module Routes
      class CustomRoutes
        attr_reader :app, :model_name, :api

        def initialize(model_name, app, api)
          @model_name = model_name
          @app        = app
          @api        = api
        end

        def build!(&block)
          instance_exec(&block) if block_given?
          app
        end

        def member(&block)
          method, route, action = instance_exec(&block)

          api.tap do |api|
            app.send(method, "/api/v1/#{model_name}/:id/#{route}") do
              data = api.get_id(self.params[:id]).send(action)

              if data.is_a? api.resource
                api.read_instance(data, include: self.params[:include])
              else
                api.dump(data)
              end
            end
          end
        end

        def collection(&block)
          method, route, action = instance_exec(&block)

          api.tap do |api|
            app.send(method, "/api/v1/#{model_name}/#{route}") do
              options = { offset: self.params[:page].to_i * self.params[:per_page].to_i,
                          limit:  self.params[:per_page] }
              collection = api.resource.send(action, options)
              api.read_collection(collection, include: self.params[:include])
            end
          end
        end

        def get(route, options={})
          action = options[:action] || route
          [:get, route, action]
        end
      end
    end
  end
end