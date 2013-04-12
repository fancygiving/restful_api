require 'multi_json'

class RestfulApi
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def create(attrs)
  end

  def read(id)
    if id == :all
      read_all
    elsif id == :first
      read_first
    elsif id == :last
      read_last
    else
      read_id(id)
    end
  end

  def update(id, attrs)
  end

  def destroy(id)
  end

  def json(id)
    MultiJson.dump(read(id))
  end

  private

  def read_all
  end

  def read_first
  end

  def read_last
  end

  def read_id(id)
  end

end