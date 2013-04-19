require 'virtus'
require_relative '../../../lib/restful_api/client/mapper'

class Item
  include Virtus

  attribute :name
end

class Person
  include Virtus

  attribute :name, String
  attribute :item, Item
  attribute :father, Person
  attribute :friends, Array[Person]
end

describe Mapper do

  let(:person_mapper) { Mapper.new(Person) }

  describe 'basic mapping' do

    let(:person_data)   { {name: 'Brian'} }

    it 'maps data to an object' do
      expect(person_mapper.map(person_data)).to be_a(Person)
    end

    it 'gives the object attributes from the data' do
      expect(person_mapper.map(person_data).name).to eq('Brian')
    end

  end

  describe 'relations mapping' do

    let(:with_item) { {name: 'Brian', item: {name: 'Sock'} } }
    let(:with_father) { with_item.merge(father: {name: 'Bill'}) }

    it 'maps nested objects' do
      expect(person_mapper.map(with_item).item).to be_a(Item)
    end

    it 'gives those objects attributes from the data' do
      expect(person_mapper.map(with_item).item.name).to eq('Sock')
    end

    it 'maps nested objects with names different to their class' do
      expect(person_mapper.map(with_father).father).to be_a(Person)
    end

    describe 'collections' do

      let(:friends) { [{name: 'William'}, {name: 'Charles'}] }
      let(:with_friends) { {name: 'Sophie', friends: friends}}
      let(:mapping) { person_mapper.map(with_friends) }

      it 'maps a collection' do
        expect(mapping.friends).to be_an(Array)
      end

      it 'maps the correct object' do
        expect(mapping.friends.first).to be_a(Person)
      end

    end

    describe 'doubly nested objects' do

      let(:with_father_with_item) { with_item.merge(father: {name: 'Bill', item: {name: 'Shoe'}}) }
      let(:doubly_nested_mapping) { person_mapper.map(with_father_with_item) }

      it 'maps to the correct object' do
        expect(doubly_nested_mapping.father.item).to be_an(Item)
      end

      it 'assigns the attributes' do
        expect(doubly_nested_mapping.father.item.name).to eq('Shoe')
      end

    end

  end

end