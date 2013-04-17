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

  post '/api/v1/resources' do
    JsonRestfulApi.new(Resource).create(request.body.read)
  end

  get '/api/v1/resources/:id' do
    JsonRestfulApi.new(Resource).read(params[:id])
  end

  get '/api/v1/resources' do
    JsonRestfulApi.new(Resource).read(:all)
  end

  put '/api/v1/resources/:id' do
    JsonRestfulApi.new(Resource).update(params[:id], request.body.read)
  end

  delete '/api/v1/resources/:id' do
    JsonRestfulApi.new(Resource).destroy(params[:id])
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
    barry = Resource.create(name: 'Barry')
    get "api/v1/resources/#{barry.id}"
    expect(response_body).to eq(barry.attributes)
  end

  it 'reads a collection of resources' do
    get "api/v1/resources"
    expect(response_body).to eq(Resource.all.map(&:attributes))
  end

  it 'reads a collection of resources with conditions'
  it 'reads a resource with nested resources'

  it 'updates a resource' do
    scot = Resource.create(name: 'Scot')
    put "api/v1/resources/#{scot.id}", '{"name":"Lucy"}'
    lucy = Resource.find(scot.id)
    expect(response_body).to eq(lucy.attributes)
    expect(lucy.name).to eq('Lucy')
  end

  it 'deletes a resource' do
    david = Resource.create(name: 'David')
    delete "api/v1/resources/#{david.id}"
    expect(response_body).to eq(david.attributes)
  end

end