require_relative '../../lib/restful_api/client'

class Resource
  include RestfulApi::Client::Model

  attribute :id, Integer
  attribute :name, String
end

describe 'Create a new resource' do

  let(:fred) { Resource.create(name: 'Fred') }

  it 'creates a new resource' do
    expect(fred.name).to eq('Fred')
  end

  it 'persists it over the network' do
    expect(fred.id).to be_an(Integer)
  end

  it 'new and save' do
    simon = Resource.new(name: 'Simon')
    expect(simon.save).to be_true
    expect(simon.id).to be_an(Integer)
  end

end