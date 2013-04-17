class Resource < MockModel
  include SuperModel::Redis::Model
  include VirtualProperties

  has_many :nested_resources

  attributes  :name
  indexes     :name

  virtual_properties :name_with_id

  def name_with_id
    "#{id}|#{name}"
  end
end

class NestedResource < MockModel
  include SuperModel::Redis::Model

  belongs_to :resource

  attributes  :name, :resource_id
  indexes     :name, :resource_id
end

class JsonRestfulApi < MockModelRestfulApi
  include RestfulApi::Json
end

class App < Sinatra::Base
  register Sinatra::RestfulApi

  set :environment, :production
  set :restful_api_adapter, JsonRestfulApi

  restful_api :resources

  error do
    error = env['sinatra.error']
    "#{error.name} - #{error.message}\n#{error.backtrace.join("\n")}"
  end

  not_found do
    "404: NOT FOUND"
  end

end