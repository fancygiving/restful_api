require_relative '../../lib/virtual_properties'

ENV['DATABASE_URL'] = 'postgres://fancygiving:fancygiving@localhost/dataservice_test'

def symbolize_keys(hash)
  symbolized = hash.map do |key, value|
    [key.intern, value]
  end
  Hash[symbolized]
end

def load_json(json)
  results = MultiJson.load(json)
  if results.kind_of? Array
    results.map { |result| symbolize_keys(result) }
  else
    symbolize_keys(results)
  end
end

DataMapper.setup(:default, {adapter: "redis"})

class Person
  include DataMapper::Resource
  include VirtualProperties

  property :id,   Serial
  property :name, String

  has n, :things

  virtual_properties :name_with_id

  def name_with_id
    "#{id}|#{name}"
  end
end

class Thing
  include DataMapper::Resource

  property :id,   Serial
  property :name, String

  belongs_to :person
end

DataMapper.finalize