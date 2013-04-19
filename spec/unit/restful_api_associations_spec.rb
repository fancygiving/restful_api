require_relative '../../lib/restful_api'
require_relative '../support/mock_model'
require_relative '../support/mock_model_restful_api'

class Item < MockModel
  belongs_to :list
  belongs_to :owner

  def recipient
    User.find(recipient_id)
  end
end

class Owner < MockModel
  has_many :items
end

class User < MockModel
end

class List < MockModel
  has_many :items
end

describe 'RestfulApi associations' do

  let(:list_api) { MockModelRestfulApi.new(List) }
  let(:item_api) { MockModelRestfulApi.new(Item) }

  attr_reader :list, :item, :owner, :recipient
  before do
    @list       = List.create(name: 'Tools')
    @owner      = Owner.create(name: 'Owen')
    @recipient  = User.create(name: 'Ulysses')
    @item       = Item.create(name: 'Screwdriver',
                          list_id: list.id,
                          owner_id: owner.id,
                          recipient_id: recipient.id)
  end

  it 'can read an arbitrary collection' do
    items = item_api.read_collection(list.items)
    expect(items).to eq([item.attributes])
  end

  it 'can read an arbitrary collection with associations' do
    items = item_api.read_collection(list.items, include: :owner)
    expect(items).to eq([item.attributes.merge(owner: owner.attributes)])
  end

  it 'returns an associated collection' do
    items = list_api.read(list.id, include: [:items])['items']
    expect(items).to eq([item.attributes])
  end

  it 'returns an associated instance' do
    item_list = item_api.read(item.id, include: [:list])['list']
    expect(item_list).to eq(list.attributes)
  end

  it 'returns an associated instance with a name different to its class' do
    item_recipient = item_api.read(item.id, include: [:recipient])['recipient']
    expect(item_recipient).to eq(recipient.attributes)
  end

  it 'returns multiple associated instances' do
    results = item_api.read(item.id, include: [:list, :owner])
    expect(results['list']).to eq(list.attributes)
    expect(results['owner']).to eq(owner.attributes)
  end

  it 'returns associated collections' do
    results = list_api.read(list.id, include: :items)
    expect(results['items']).to eq([item.attributes])
  end

  it 'returns nested associations' do
    results = list_api.read(list.id, include: [{items: {include: :owner}}])
    item_with_owner = item.attributes.merge(owner: owner.attributes)
    expect(results['items']).to eq([item_with_owner])
  end

end