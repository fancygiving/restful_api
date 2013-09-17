require 'dm-core'
require 'dm-redis-adapter'
require 'dalli'

# require_relative 'integration_helper'
# require_relative '../../lib/restful_api'
#
# describe 'RestfulApi::DataMapper Caching' do
#   let(:cache) { RestfulApi::Caching }
#   let(:api) { RestfulApi::DataMapper.new(Person) }
#   let(:dave) { Person.create(name: 'Dave') }
#
#   before :all do
#     Person.all.map(&:destroy)
#     Thing.all.map(&:destroy)
#   end
#
#   before do
#     cache.cache_store = Dalli::Client.new
#     api.extend(cache)
#   end
#
#   describe '#read' do
#     it 'tries to read from the cache where possible' do
#       expect(cache).to receive(:cache_store)
#       api.read(dave.id)
#     end
#
#     it 'has an option to skip the cache' do
#       pending
#       expect(cache).to_not receive(:cache_store)
#       api.read(dave.id, cache: false)
#     end
#   end
# end