require_relative 'integration_helper'
require_relative '../../models/init'
require_relative '../../lib/virtual_properties'

class Partner
  include VirtualProperties

  virtual_properties :name_with_id

  def name_with_id
    "#{id}|#{name}"
  end
end

describe VirtualProperties do

  let(:partner) { Partner.first }
  let(:name_with_id) { "#{partner.id}|#{partner.name}" }

  it 'returns virtual properties for a datamapper model' do
    expect(partner.attributes_with_virtual[:name_with_id]).to eq(name_with_id)
  end

  it 'doesnt intefere with saving a datamapper model' do
    partner = Partner.new(name: "Jimmy Jim Jam")
    expect { partner.save! }.to_not raise_error
    expect(partner.attributes_with_virtual[:name_with_id]).to match("Jimmy Jim Jam")
  end

  it 'returns conditionally on virtual properties' do
    partner = Partner.create!(name: "Sammy Shim Sham")
    partners = Partner.all_with_virtual(name_with_id: partner.name_with_id)
    expect(partners.first).to eq(partner)
  end

end