require_relative '../../lib/restful_api'
require_relative '../support/mock_model'

describe 'RestfulApi associations' do

  let(:api) { HashRestfulApi.new(MockModel) }

  before do
    MockModel.collection = [MockModel.new(name: 'Dave'),
                            MockModel.new(name: 'Serina')]
  end

  it 'returns an associated model' do

  end

end