require_relative '../support/mock_model'
require_relative '../../lib/virtual_properties'

class Item < MockModel
  include VirtualProperties

  virtual_properties :price_plus_vat

  def price_plus_vat
    price + price * 0.2
  end
end


describe VirtualProperties do

  it 'includes virtual properties in the attributes hash' do
    attrs = { 'name' => 'Book', 'price' => 20 }
    book = Item.new(attrs)
    expect(book.attributes_with_virtual).to eq(attrs.merge('price_plus_vat' => 24))
  end

  it 'does not set virtual properties in the attributes hash' do
    attrs = { 'name' => 'Book', 'price' => 20,  'price_plus_vat' => 3000}
    book = Item.new(attrs)
    expect { book.attributes.fetch('price_plus_vat') }.to raise_error(KeyError)
  end

end