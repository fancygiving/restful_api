require_relative 'integration_helper'
require_relative '../../models/init'
require_relative '../../lib/restful_api'

describe RestfulApi do

  def partner_attributes_with_brands(partner)
    brands = partner.brands.to_a.map(&:attributes).map(&:stringify_keys)
    partner.attributes.stringify_keys.merge('brands' => brands)
  end

  let(:api) { DataMapperRestfulApi.new(Partner) }
  let(:partner) { Partner.get(1) }

  it 'creates a new partner object' do
    expect {
      api.create(name: "A New Partner", logo: "test_image.jpg")
    }.to change(Partner, :count).by(1)
  end

  it 'returns an attributes hash' do
    expect(api.read(1)).to be_a Hash
  end

  it 'returns a collection of attribute hashes' do
    expect(api.read(:all).first).to be_a Hash
  end

  it 'returns a collection with given conditions' do
    expect(api.read(name: partner.name)).to eq([partner.attributes.stringify_keys])
  end

  it 'returns a collection with nested includes' do
    expected_results = Partner.all.to_a.map do |partner|
      partner_attributes_with_brands(partner)
    end
    expect(api.read(:all, include: :brands)).to eq(expected_results)
  end

  it 'returns a collection with conditions and includes' do
    expect(api.read({ name: partner.name }, { include: :brands }))
      .to eq([partner_attributes_with_brands(partner)])
  end

  it 'reads partner attributes' do
    expect(api.read(1)['name']).to eq(Partner.get(1).name)
  end

  it 'reads a partner object as json' do
    expect(load_json(api.json(1))[:name]).to eq(Partner.get(1).name)
  end

  it 'reads a partner collection as json' do
    expect(load_json(api.json(:all)).first[:name]).to eq(Partner.first.name)
  end

  it 'updates a partner in the database' do
    partner = Partner.first
    api.update(partner.id, name: "WoopWoopEternalRainClouds")
    expect(Partner.first.name).to eq("WoopWoopEternalRainClouds")
  end

  it 'destroys a partner in the database' do
    expect {
      api.destroy(Partner.last.id)
    }.to change(Partner, :count).by(-1)
  end

  it 'returns the attributes of the object which has just been destroyed' do
    partner = Partner.last
    expect(api.destroy(partner.id)).to eq(partner.attributes.stringify_keys)
  end

end