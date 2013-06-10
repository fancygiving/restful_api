require_relative '../restful_api'
require_relative 'restful_api/helpers'

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

      post "/api/v1/#{name}" do
        begin
          send("#{name}_api").create(request.body.read)
        rescue ::RestfulApi::InvalidAttributesError => e
          halt 422, MultiJson.dump({error: e.message})
        end
      end

      get "/api/v1/#{name}/new" do
        send("#{name}_api").build
      end

      get "/api/v1/#{name}/:id" do
        begin
          send("#{name}_api").read(params[:id], include: params[:include])
        rescue ::RestfulApi::NotFoundError => e
          raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
        end
      end

      get "/api/v1/#{name}" do
        api = send("#{name}_api")
        api.read(read_conditions(api.resource), include: params[:include])
      end

      put "/api/v1/#{name}/:id" do
        begin
          send("#{name}_api").update(params[:id], request.body.read)
        rescue ::RestfulApi::NotFoundError => e
          raise Sinatra::NotFound, "404 NOT FOUND: Record with id #{params[:id]} not found"
        rescue ::RestfulApi::InvalidAttributesError => e
          halt 422, MultiJson.dump({error: e.message})
        end
      end

      delete "/api/v1/#{name}/:id" do
        send("#{name}_api").destroy(params[:id])
      end
    end
  end

  register RestfulApi
end
