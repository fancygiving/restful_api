require 'rack/test'
require_relative 'mock_app'

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

  describe 'creating a resource' do

    it 'creates a resource' do
      post 'api/v1/resources', '{"name":"Linda"}'
      expect(response_body).to eq(Resource.last.attributes)
    end

  end

  it 'returns a blank resource' do
    get 'api/v1/resources/new'
    expect(response_body).to eq({'name' => nil})
  end

  describe 'reads a resource' do

    let(:barry) { Resource.create(name: 'Barry') }

    it 'single resource' do
      get "api/v1/resources/#{barry.id}"
      expect(response_body).to eq(barry.attributes)
    end

    it 'returns 404 if the resources does not exist' do
      get "api/v1/resources/999999999"
      expect(last_response.status).to eq(404)
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
      get "api/v1/resources", {name: 'Jehoshaphat'}
      expect(response_body).to include(jehoshaphat.attributes)
      expect(response_body).to_not include(ish_bosheth.attributes)
    end

    it 'with conditions on virtual attributes' do
      get "api/v1/resources", {name_with_id: "#{ish_bosheth.id}|Ish Bosheth"}
      expect(response_body).to include(ish_bosheth.attributes)
      expect(response_body).to_not include(jehoshaphat.attributes)
    end

    it 'throws an error when conditions dont exist' do
      get "api/v1/resources", {does_not: :exist}
      expect(last_response.status).to be(500)
    end

    it 'returns an empty array when conditions are not met by any model' do
      get "api/v1/resources", {name: 'This is not a name'}
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
      get "api/v1/resources", {name: 'Jehoshaphat', include: :nested_resources}
      expect(response_body).to include(resource_with_nested_resources(jehoshaphat))
      expect(response_body).to_not include(resource_with_nested_resources(ish_bosheth))
    end
  end

  describe 'updates a resource' do
    it 'updates' do
      scot = Resource.create(name: 'Scot')
      put "api/v1/resources/#{scot.id}", '{"name":"Lucy"}'
      lucy = Resource.find(scot.id)
      expect(response_body).to eq(lucy.attributes)
      expect(lucy.name).to eq('Lucy')
    end
  end

  describe 'deletes a resource' do
    it 'deletes' do
      david = Resource.create(name: 'David')
      delete "api/v1/resources/#{david.id}"
      expect(response_body).to eq(david.attributes)
    end
  end

  describe 'custom routes' do

    it 'adds a member route' do
      ezekiel = Resource.create(name: 'Ezekiel')
      get "api/v1/resources/#{ezekiel.id}/friend"
      expect(response_body).to eq(ezekiel.friend.attributes)
    end

  end

end