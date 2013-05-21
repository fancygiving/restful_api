require_relative 'integration_helper'
require_relative '../../lib/restful_api'

describe 'DataMapper JSON integration' do

  let(:api) { RestfulApi::DataMapper.new(Person) }

  before do
    api.extend RestfulApi::Json
  end

  describe '#create' do

    it 'creates a new record' do
      expect {
        api.create(name: "A New Person")
      }.to change(Person, :count)
    end

    it 'returns the record as json' do
      expect(api.create(name: 'Barry')).to include('"name":"Barry"')
    end

  end

  describe '#build' do

    it 'builds a resource with default values' do
      expect(api.build).to eq("{\"name\":\"noname\",\"name_with_id\":\"|noname\"}")
    end

  end

end