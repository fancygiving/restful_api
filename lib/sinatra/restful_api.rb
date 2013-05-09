require_relative '../restful_api'

module Sinatra
  module RestfulApi
    def self.registered(app)
      app.helpers Helpers
    end

    class ConditionsParser
      def self.parse(conditions, model)
        conditions.empty? ? :all : conditions
      end
    end

    module Helpers
      def restful_api_for(name)
        restful_json_api(settings.restful_api_adapter,
                          name.to_s.singularize.classify.constantize)
      end

      def restful_json_api(adapter, klass)
        adapter.new(klass).tap do |adapter|
          restful_json_api_setup(adapter)
        end
      end

      def restful_json_api_setup(adapter)
        json = ::RestfulApi::Json
        json.include_root_in_json = setting_or_default(:include_root_in_json, false)
        adapter.extend json
      end

      def read_conditions(resource)
        conditions = params.except('include')
        conditions_parser.parse(conditions, resource)
      end

      def conditions_parser
        setting_or_default(:restful_api_conditions_parser, ConditionsParser)
      end

      def setting_or_default(setting, default)
        settings.respond_to?(setting) ? settings.send(setting) : default
      end
    end

    def restful_api(name)
      helpers do
        define_method("#{name}_api") do
          instance_variable_get("@#{name}_api") ||
            instance_variable_set("@#{name}_api", restful_api_for(name))
        end
      end

      post "/api/v1/#{name}" do
        send("#{name}_api").create(request.body.read)
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
          halt 400, "400 BAD REQUEST: #{e.message}"
        end
      end

      delete "/api/v1/#{name}/:id" do
        send("#{name}_api").destroy(params[:id])
      end
    end
  end

  register RestfulApi
end
