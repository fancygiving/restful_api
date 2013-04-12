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