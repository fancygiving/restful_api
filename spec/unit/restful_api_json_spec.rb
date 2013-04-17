require_relative '../../lib/restful_api'
require_relative '../../lib/restful_api/json'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

describe RestfulApi do

  let(:api) { MockModelRestfulApi.new(MockModel) }

  attr_reader :bob, :briony
  before :all do
    @bob = MockModel.create(name: 'Bob')
    @briony = MockModel.create(name: 'Briony')
  end

  before do
    api.extend RestfulApi::Json
  end

  describe 'return as JSON' do

    def json_results(instance)
      '{"id":' + instance.id.to_s + ',"name":"' + instance.name + '"}'
    end

    it 'returns an instance as json' do
      expect(api.read(bob.id)).to eq(json_results(bob))
    end

    it 'returns a collection as json' do
      expect(api.read(:all)).to match(json_results(bob))
    end

    it 'returns the created resource as json' do
      expect(api.create('{"name":"Michael"}')).to eq(json_results(MockModel.last))
    end

    it 'returns the updated resource as json' do
      expect(api.update(briony.id, '{"name":"william"}')).to eq(json_results(briony))
    end

    it 'returns the destroyed resource as json' do
      expect(api.destroy(briony.id)).to eq(json_results(briony))
    end

  end

end