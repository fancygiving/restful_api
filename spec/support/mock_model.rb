require 'supermodel'

module RestfulApi
  class ReadOptions
    def mock_model_options
      return (0..-1) unless offset.present? && limit.present?
      (offset...offset + limit)
    end
  end
end

class MockModel < SuperModel::Base
  def to_h
    Hash[attributes.sort]
  end
end