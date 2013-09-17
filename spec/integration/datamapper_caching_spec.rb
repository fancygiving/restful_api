require 'dm-core'
require 'dm-redis-adapter'
require 'dalli'

require_relative 'integration_helper'
require_relative '../../lib/restful_api'

describe 'RestfulApi::DataMapper Caching' do
  before :all do
    Person.all.map(&:destroy)
    Thing.all.map(&:destroy)
    RestfulApi::Caching.cache_store = Dalli::Client.new
  end

  after :all do
    RestfulApi::Caching.cache_store = nil
  end

  let(:cache) { RestfulApi::Caching }
  let(:api) { RestfulApi::DataMapper.new(Person) }
  let(:dave) { Person.create(name: 'Dave') }

  before { api.extend(RestfulApi::Caching) }

  describe '#read' do
    it 'tries to read from the cache where possible' do
      expect(cache).to receive(:cache_store)
      api.read(dave.id)
    end

    it 'has an option to skip the cache' do
      expect(cache).to_not receive(:cache_store)
      api.read(dave.id, cache: false)
    end
  end

  describe '#update' do
    it 'returns a fresh copy of the updated resource' do
      expect(cache).to_not receive(:cache_store)
      response = api.update(dave.id, name: "WoopWoopEternalRainClouds")
      expect(response['name']).to eq("WoopWoopEternalRainClouds")
    end
  end
end