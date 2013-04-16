require 'supermodel'

class MockModel < SuperModel::Base
  def to_h
    Hash[attributes.sort]
  end
end