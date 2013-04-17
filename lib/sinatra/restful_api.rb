require_relative '../restful_api'

module Sinatra
  module RestfulApi
    def restful_api(name)
      helpers do
        def restful_api_for(name)
          klass = name.to_s.singularize.classify.constantize
          settings.restful_api_adapter.new(klass).tap do |adapter|
            adapter.extend ::RestfulApi::Json
          end
        end

        define_method("#{name}_api") do
          instance_variable_get("@#{name}_api") ||
            instance_variable_set("@#{name}_api", restful_api_for(name))
        end
      end

      post "/api/v1/#{name}" do
        send("#{name}_api").create(request.body.read)
      end

      get "/api/v1/#{name}/:id" do
        send("#{name}_api").read(params[:id], include: params[:include])
      end

      get "/api/v1/#{name}" do
        send("#{name}_api").read(params[:where] || :all, include: params[:include])
      end

      put "/api/v1/#{name}/:id" do
        send("#{name}_api").update(params[:id], request.body.read)
      end

      delete "/api/v1/#{name}/:id" do
        send("#{name}_api").destroy(params[:id])
      end
    end
  end

  register RestfulApi
end
