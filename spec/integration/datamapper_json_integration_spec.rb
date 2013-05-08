require_relative 'integration_helper'
require_relative '../../lib/restful_api'

describe 'DataMapper JSON integration' do

  describe '#create' do

    let(:api) { RestfulApi::DataMapper.new(Person) }

    before do
      api.extend RestfulApi::Json
    end

    it 'creates a new record' do
      expect {
        api.create(name: "A New Person")
      }.to change(Person, :count).by(1)
    end

    it 'returns the record as json' do
      expect(api.create(name: 'Barry')).to include('"name":"Barry"')
    end

  end

end