require 'sinatra/base'
require 'rack/test'
require 'redis'

require_relative '../../lib/sinatra/restful_api'
require_relative '../../lib/virtual_properties'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

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

describe App do
  include Rack::Test::Methods

  alias :app :subject

  def response_body
    MultiJson.load(last_response.body)
  rescue MultiJson::LoadError
    last_response.body
  end

  def resource_with_nested_resources(resource)
    nested_resources = resource.nested_resources.map(&:attributes)
    resource.attributes.merge(nested_resources: nested_resources)
  end

  before :all do
    Resource.destroy_all
    NestedResource.destroy_all
  end

  it 'creates a resource' do
    post 'api/v1/resources', '{"name":"Linda"}'
    expect(response_body).to eq(Resource.last.attributes)
  end

  describe 'reads a resource' do

    let(:barry) { Resource.create(name: 'Barry') }

    it 'single resource' do
      get "api/v1/resources/#{barry.id}"
      expect(response_body).to eq(barry.attributes)
    end

    it 'include nested resource' do
      sock = NestedResource.create(name: 'Sock', resource_id: barry.id)
      get "api/v1/resources/#{barry.id}", {include: :nested_resources}
      expect(response_body).to eq(resource_with_nested_resources(barry))
    end

  end

  describe 'reads a collection of resources' do

    attr_reader :jehoshaphat, :ish_bosheth
    before do
      @jehoshaphat = Resource.create(name: 'Jehoshaphat')
      @ish_bosheth = Resource.create(name: 'Ish Bosheth')
    end

    it 'all' do
      get "api/v1/resources"
      expect(response_body).to eq(Resource.all.map(&:attributes))
    end

    it 'with conditions' do
      get "api/v1/resources", {where: {name: 'Jehoshaphat'}}
      expect(response_body).to include(jehoshaphat.attributes)
      expect(response_body).to_not include(ish_bosheth.attributes)
    end

    it 'with conditions on virtual attributes' do
      get "api/v1/resources", {where: {name_with_id: "#{ish_bosheth.id}|Ish Bosheth"}}
      expect(response_body).to include(ish_bosheth.attributes)
      expect(response_body).to_not include(jehoshaphat.attributes)
    end

    it 'throws an error when conditions dont exist' do
      get "api/v1/resources", {where: {does_not: :exist}}
      expect(last_response.status).to be(500)
    end

    it 'returns an empty array when conditions are not met by any model' do
      get "api/v1/resources", {where: {name: 'This is not a name'}}
      expect(response_body).to eq([])
    end

    it 'with nested resources' do
      get "api/v1/resources", {include: :nested_resources}
      expected_results = Resource.all.map { |r| resource_with_nested_resources(r) }
      expect(response_body).to eq(expected_results)
    end

    it 'throws an error when nested resource does not exist' do
      get "api/v1/resources", {include: :non_existent_resources}
      expect(last_response.status).to be(500)
    end

    it 'with conditions and nested resources' do
      NestedResource.create(name: 'Shirt', resource_id: jehoshaphat.id)
      get "api/v1/resources", {where: {name: 'Jehoshaphat'}, include: :nested_resources}
      expect(response_body).to include(resource_with_nested_resources(jehoshaphat))
      expect(response_body).to_not include(resource_with_nested_resources(ish_bosheth))
    end
  end

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