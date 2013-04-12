require_relative '../../lib/restful_api'
require_relative '../support/mock_model'

class Item < MockModel
  def list
    List.read(attributes[:list_id])
  end
end

class List < MockModel
  def items
    Item.read(:all).select { |item| item.list_id == id }
  end
end

describe 'RestfulApi associations' do

  let(:list_api) { MockModelRestfulApi.new(List) }
  let(:item_api) { MockModelRestfulApi.new(Item) }

  before do
    List.reset!
    Item.reset!
    List.create(name: 'Tools')
    Item.create(name: 'Screwdriver', list_id: 1)
  end

  it 'returns an associated model' do
    list_api.read(1, include: :item)
  end

end