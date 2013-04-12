require_relative 'integration_helper'
require_relative '../../models/init'
require_relative '../../lib/restful_api'

describe RestfulApi do

  let(:api) { DataMapperRestfulApi.new(Partner) }

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

  it 'reads partner attributes' do
    expect(api.read(1)[:name]).to eq(Partner.get(1).name)
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

end