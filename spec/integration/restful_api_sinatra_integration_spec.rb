require 'sinatra/base'
require 'rack/test'
require 'redis'
require_relative '../../lib/restful_api'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

class Resource < MockModel
  include SuperModel::Redis::Model

  attributes :name
  indexes :name
end

class JsonRestfulApi < MockModelRestfulApi
  include RestfulApi::Json
end

class App < Sinatra::Base

  set :environment, :production

  get '/api/v1/resources/:id' do
    JsonRestfulApi.new(Resource).read(params[:id])
  end

  get '/api/v1/resources' do
    JsonRestfulApi.new(Resource).read(:all)
  end

  post '/api/v1/resources' do
    JsonRestfulApi.new(Resource).create(request.body.read)
  end

  error do
    MultiJson.dump(error: env['sinatra.error'].to_s)
  end

  not_found do
    MultiJson.dump(error: env['sinatra.error'].to_s)
  end

end

describe App do
  include Rack::Test::Methods

  alias :app :subject

  def response_body
    MultiJson.load(last_response.body)
  rescue MultiJson::LoadError
    last_response.body
  end

  it 'creates a resource' do
    post 'api/v1/resources', '{"name":"Linda"}'
    expect(response_body).to eq(Resource.last.attributes)
  end

  it 'reads a resource' do
    resource = Resource.create(name: 'Barry')
    get "api/v1/resources/#{resource.id}"
    expect(response_body).to eq(resource.attributes)
  end

  it 'reads a collection of resources' do
    get "api/v1/resources"
    expect(response_body).to eq(Resource.all.map(&:attributes))
  end

  it 'reads a collection of resources with conditions'
  it 'reads a resource with nested resources'

  it 'updates a resource'
  it 'deletes a resource'

end