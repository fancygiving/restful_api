require_relative '../../lib/restful_api'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

describe RestfulApi do

  let(:api) { MockModelRestfulApi.new(MockModel) }

  attr_reader :dave, :serina
  before :all do
    @dave = MockModel.create(name: 'Dave')
    @serina = MockModel.create(name: 'Serina')
  end

  describe 'CRUD interface' do

    it 'fetches an instance of the resource' do
      expect(api.read(dave.id)).to eq(dave.attributes)
    end

    it 'returns an error if the resource cannot be found' do
      expect { api.read(9999999) }.to raise_error(RestfulApi::NotFoundError)
    end

    it 'fetches all instances of the resource' do
      expect(api.read(:all)).to include(dave.attributes, serina.attributes)
    end

    it 'fetches all instances with given conditions' do
      expect(api.read(name: 'Dave')).to eq([dave.attributes])
    end

    it 'creates a new item' do
      api.create({name: 'Sarah'})
      expect(api.read(:last)['name']).to eq('Sarah')
    end

    it 'updates an item in the collection' do
      api.update(serina.id, {name: 'Alan'})
      expect(api.read(serina.id)['name']).to eq('Alan')
    end

    it 'destroys an item from the collection' do
      api.destroy(serina.id)
      expect { api.read(serina.id) }.to raise_error(RestfulApi::NotFoundError)
    end

  end

  describe 'reading a collection' do

    it 'can read an arbitrary collection of models' do
      collection = api.read_collection(MockModel.all)
      expect(collection).to eq(MockModel.all.map!(&:attributes))
    end

  end

end