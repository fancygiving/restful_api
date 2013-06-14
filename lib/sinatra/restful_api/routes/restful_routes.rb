module Sinatra
  module RestfulApi
    module Routes
      class RestfulRoutes
        attr_reader :model_name, :app, :api

        def initialize(model_name, app, api)
          @model_name = model_name.to_s.pluralize
          @app        = app
          @api        = api
        end

        def build!(&block)
          build_create_route!
          build_new_route!
          build_read_instance_route!
          build_read_collection_route!
          build_update_route!
          build_delete_route!
          app
        end

        private

        def build_create_route!
          api.tap do |api|
            app.post "/api/v1/#{model_name}" do
              begin
                api.create(request.body.read)
              rescue ::RestfulApi::InvalidAttributesError => e
                halt 422, MultiJson.dump({error: e.message})
              end
            end
          end
        end

        def build_new_route!
          api.tap do |api|
            app.get "/api/v1/#{model_name}/new" do
              api.build
            end
          end
        end

        def build_read_instance_route!
          api.tap do |api|
            app.get "/api/v1/#{model_name}/:id" do
              begin
                api.read(Integer(params[:id], 10), include: params[:include])
              rescue ArgumentError => e
                pass # pass if id in params is not an Integer
              rescue ::RestfulApi::NotFoundError => e
                raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
              end
            end
          end
        end

        def build_read_collection_route!
          api.tap do |api|
            app.get "/api/v1/#{model_name}" do
              options = params.slice('include', 'page', 'per_page').to_options
              api.read(read_conditions(api.resource), options)
            end
          end
        end

        def build_update_route!
          api.tap do |api|
            app.put "/api/v1/#{model_name}/:id" do
              begin
                api.update(Integer(params[:id], 10), request.body.read)
              rescue ArgumentError => e
                pass # pass if id in params is not an Integer
              rescue ::RestfulApi::NotFoundError => e
                raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
              rescue ::RestfulApi::InvalidAttributesError => e
                halt 422, MultiJson.dump({error: e.message})
              end
            end
          end
        end

        def build_delete_route!
          api.tap do |api|
            app.delete "/api/v1/#{model_name}/:id" do
              api.destroy(params[:id])
            end
          end
        end
      end
    end
  end
end