require 'virtus'
require 'faraday'

class Person
  include Virtus

  def self.create(attrs)
    self.new(attrs).save
  end

  def save
    Faraday.post('http://localhost:4567/api/v1/people', attributes)
  end

  attribute :name, String
end

describe 'Create a new resource' do

  it 'creates a new resource' do
    person = Person.create(name: 'Fred')
    expect(person.name).to eq('Fred')
  end

end