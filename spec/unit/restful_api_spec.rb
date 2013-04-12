require_relative '../../lib/restful_api'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

describe RestfulApi do

  let(:api) { MockModelRestfulApi.new(MockModel) }

  before do
    MockModel.reset!
    MockModel.create(name: 'Dave')
    MockModel.create(name: 'Serina')
  end

  describe 'CRUD interface' do

    it 'fetches an instance of the resource' do
      expect(api.read(1)).to eq({id: 1, name: 'Dave'})
    end

    it 'fetches all instances of the resource' do
      expect(api.read(:all)).to eq([{id: 1, name: 'Dave'}, {id: 2, name: 'Serina'}])
    end

    it 'creates a new item' do
      api.create({name: 'Sarah'})
      expect(api.read(:last)).to eq({id: 3, name: 'Sarah'})
    end

    it 'updates an item in the collection' do
      api.update(2, {name: 'Alan'})
      expect(api.read(2)[:name]).to eq('Alan')
    end

    it 'destroys an item from the collection' do
      api.destroy(1)
      expect(api.read(1)).to eq(nil)
    end

  end

  describe 'return as JSON' do

    it 'returns an instance as json' do
      expect(api.json(1)).to eq('{"id":1,"name":"Dave"}')
    end

    it 'returns a collection as json' do
      expect(api.json(:all)).to eq('[{"id":1,"name":"Dave"},{"id":2,"name":"Serina"}]')
    end

  end

end