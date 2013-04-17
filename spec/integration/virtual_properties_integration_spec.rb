require_relative 'integration_helper'
require_relative '../../lib/virtual_properties'

describe VirtualProperties do

  let(:person) { Person.first }
  let(:name_with_id) { "#{person.id}|#{person.name}" }

  it 'returns virtual properties for a datamapper model' do
    expect(person.attributes_with_virtual[:name_with_id]).to eq(name_with_id)
  end

  it 'doesnt intefere with saving a datamapper model' do
    person = Person.new(name: "Jimmy Jim Jam")
    expect { person.save }.to_not raise_error
    expect(person.attributes_with_virtual[:name_with_id]).to match("Jimmy Jim Jam")
  end

  it 'returns conditionally on virtual properties' do
    person = Person.create(name: "Sammy Shim Sham")
    people = Person.all_with_virtual(name_with_id: person.name_with_id)
    expect(people.first).to eq(person)
  end

end