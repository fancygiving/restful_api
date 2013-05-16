require 'dm-core'
require 'dm-redis-adapter'

require_relative 'integration_helper'
require_relative '../../lib/restful_api'

describe RestfulApi::DataMapper do

  def person_attributes_with_things(partner)
    things = partner.things.to_a.map!(&:attributes_with_virtual).map!(&:stringify_keys)
    partner.attributes_with_virtual.stringify_keys.merge('things' => things)
  end

  before :all do
    Person.all.map(&:destroy)
    Thing.all.map(&:destroy)
  end

  let(:api) { RestfulApi::DataMapper.new(Person) }
  let(:dave) { Person.create(name: 'Dave') }

  it 'creates a new partner object' do
    expect {
      api.create(name: "A New Person")
    }.to change(Person, :count).by(1)
  end

  it 'throws an error for bad input' do
    expect {
      api.create(lounge_chair_count: 3)
    }.to raise_error(RestfulApi::InvalidAttributesError)
  end

  it 'returns a new object' do
    expect(api.build).to eq({'id' => nil, 'name' => nil, 'name_with_id' => '|'})
  end

  it 'returns an attributes hash' do
    expect(api.read(dave.id)).to eq(dave.attributes_with_virtual.stringify_keys)
  end

  it 'returns an attributes hash with virtual conditions' do
    expect(api.read(dave.id)).to have_key('name_with_id')
  end

  it 'returns a collection of attribute hashes' do
    expect(api.read(:all).first).to be_a Hash
  end

  it 'returns a collection with given conditions' do
    expect(api.read(name: dave.name))
      .to include(dave.attributes_with_virtual.stringify_keys)
  end

  it 'returns a collection with nested conditions' do
    thing_api = RestfulApi::DataMapper.new(Thing)
    thing = Thing.create(name: 'Sofa', person_id: dave.id)
    expect(thing_api.read({person: {name: 'Dave'}}))
      .to include(thing.attributes.stringify_keys)
  end

  it 'returns a collection with virtual conditions' do
    expect(api.read(name_with_id: dave.name_with_id))
      .to include(dave.attributes_with_virtual.stringify_keys)
  end

  it 'returns a collection with nested includes' do
    expected_results = person_attributes_with_things(dave)
    expect(api.read(:all, include: :things)).to include(expected_results)
  end

  it 'returns a collection with conditions and includes' do
    expect(api.read({ name: dave.name }, { include: :things }))
      .to include(person_attributes_with_things(dave))
  end

  it 'updates a partner in the database' do
    brian = Person.create!(name: 'Brian')
    api.update(brian.id, name: "WoopWoopEternalRainClouds")
    expect(Person.get(brian.id).name).to eq("WoopWoopEternalRainClouds")
  end

  it 'raises a not found error if the record is not found' do
    expect {
      api.update(99999999, name: "WoopWoopEternalRainClouds")
    }.to raise_error(RestfulApi::NotFoundError)
  end

  it 'raises an error if the attributes passed are incorrect' do
    lukasz = Person.create!(name: 'Lukasz')
    expect {
      api.update(lukasz.id, narwhal: true)
    }.to raise_error(RestfulApi::InvalidAttributesError)
  end

  it 'destroys a partner in the database' do
    expect {
      api.destroy(Person.last.id)
    }.to change(Person, :count).by(-1)
  end

  it 'returns the attributes of the object which has just been destroyed' do
    person = Person.last
    expect(api.destroy(person.id)).to eq(person.attributes_with_virtual.stringify_keys)
  end

end