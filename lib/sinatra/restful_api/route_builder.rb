require_relative 'api_factory'

module Sinatra
  module RestfulApi
    class RouteBuilder
      attr_reader :model_name, :app

      def initialize(model_name, app)
        @model_name = model_name
        @app        = app
      end

      def build_restful_routes!
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
        api_endpoint do |api|
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
        api_endpoint do |api|
          app.get "/api/v1/#{model_name}/new" do
            api.build
          end
        end
      end

      def build_read_instance_route!
        api_endpoint do |api|
          app.get "/api/v1/#{model_name}/:id" do
            begin
              api.read(params[:id], include: params[:include])
            rescue ::RestfulApi::NotFoundError => e
              raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
            end
          end
        end
      end

      def build_read_collection_route!
        api_endpoint do |api|
          app.get "/api/v1/#{model_name}" do
            api.read(read_conditions(api.resource), include: params[:include])
          end
        end
      end

      def build_update_route!
        api_endpoint do |api|
          app.put "/api/v1/#{model_name}/:id" do
            begin
              api.update(params[:id], request.body.read)
            rescue ::RestfulApi::NotFoundError => e
              raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
            rescue ::RestfulApi::InvalidAttributesError => e
              halt 422, MultiJson.dump({error: e.message})
            end
          end
        end
      end

      def build_delete_route!
        api_endpoint do |api|
          app.delete "/api/v1/#{model_name}/:id" do
            api.destroy(params[:id])
          end
        end
      end

      def api_endpoint
        yield(api)
      end

      def api
        @api ||= ApiFactory.new(model_name, app.settings).build_restful_api!
      end
    end
  end
end