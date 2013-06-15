require 'rack/test'
require_relative 'mock_app'

describe Sinatra::RestfulApi::Routes do
  include Rack::Test::Methods

  def app; App; end

  def routes
    Sinatra::RestfulApi::Routes
  end

  def response_body
    MultiJson.load(last_response.body)
  rescue MultiJson::LoadError
    last_response.body
  end

  class Resource
    def self.tomorrow_resources(offset=nil, limit=nil)
      all
    end

    def self.top_ten(offset=nil, limit=nil)
      all
    end

    def countdown
      {countdown: [1,2,3,4]}
    end

    def opposite
      self.class.first
    end
  end

  before do
    routes.draw('resources', app) do
      member { get :countdown }
      member { get :opposite }
      collection { get :tomorrow, action: :tomorrow_resources }
      collection { get :top_ten }
    end
  end

  describe 'a collection route' do
    it 'accepts a collection block with custom get routes' do
      get 'api/v1/resources/tomorrow'
      expect(last_response).to be_ok
    end

    it 'calls the specified action as a class method' do
      get 'api/v1/resources/tomorrow'
      expect(response_body).to eq(Resource.tomorrow_resources.map(&:attributes))
    end

    it 'calls the class method with the same name as the route by default' do
      get 'api/v1/resources/top_ten'
      expect(response_body).to eq(Resource.top_ten.map(&:attributes))
    end
  end

  describe 'a member route' do
    let(:resource) { Resource.last }

    it 'accepts a member block with custom routes' do
      get "api/v1/resources/#{resource.id}/countdown"
      expect(last_response).to be_ok
    end

    it 'calls the action as an instance method on the resource' do
      get "api/v1/resources/#{resource.id}/countdown"
      expect(response_body).to eq({'countdown' => [1,2,3,4]})
    end

    it 'can handle instances of the resource as output' do
      get "api/v1/resources/#{resource.id}/opposite"
      expect(response_body).to eq(resource.opposite.attributes)
    end
  end

end