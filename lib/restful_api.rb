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

class HashRestfulApi < RestfulApi
  def create(attrs)
    resource.create(attrs)
  end

  def update(id, attrs)
    read_id(id).update(attrs)
  end

  def destroy(id)
    resource.delete(id)
  end

  private

  def read_all
    resource.all
  end

  def read_first
    read_all.first
  end

  def read_last
    read_all.last
  end

  def read_id(id)
    resource.get(id)
  end

end

class DataMapperRestfulApi < RestfulApi
  def create(attrs)
    resource.create(attrs)
  end

  def update(id, attrs)
    read_id(id).update(attrs)
  end

  def destroy(id)
    read_id(id).destroy
  end

  private

  def read_all
    resource.all
  end

  def read_first
    resource.first
  end

  def read_last
    resource.last
  end

  def read_id(id)
    resource.get(id)
  end

end