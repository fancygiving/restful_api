require 'faraday'
require 'multi_json'

class Mapper

  attr_reader :objekt

  def initialize(objekt)
    @objekt = objekt
  end

  def create(attrs={})
    MultiJson.load(Faraday.post('http://localhost:4567/api/v1/resources', MultiJson.dump(attrs)).body)
  end

  def map(data)
    objekt.new(data)
  end
end