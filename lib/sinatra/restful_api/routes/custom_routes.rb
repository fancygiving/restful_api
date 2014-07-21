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
          @route_type = :member
          instance_exec(&block)
        end

        def collection(&block)
          @route_type = :collection
          instance_exec(&block)
        end

        def get(route, options={})
          action = options[:action] || route
          case @route_type
            when :collection then collection_route(:get, route, action)
            when :member then member_route(:get, route, action)
            else raise "Wrong route description. Should be collection or member"
          end
        end
        
        def collection_route(method, route, action)
          api.tap do |api|
            app.send(method, "/api/v1/#{model_name}/#{route}") do
              options = api.read_options(params)
              api.read_collection(api.resource.send(action, options), options.include)
            end
          end
        end
        
        def member_route(method, route, action)
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
        
      end
    end
  end
end
