class DataMapperRestfulApi < RestfulApi
  def create(attrs)
    instance = resource.create(attrs)
    try_attributes(instance)
  end

  def update(id, attrs)
    get(id).update(attrs)
    read(id)
  end

  def destroy(id)
    get(id).destroy
    read(id)
  end

  private

  def read_all
    resource.all.to_a.map(&:attributes)
  end

  def read_first
    try_attributes(resource.first)
  end

  def read_last
    try_attributes(resource.last)
  end

  def read_id(id)
    try_attributes(get(id))
  end

  def try_attributes(instance)
    instance && instance.attributes
  end

  def get(id)
    resource.get(id)
  end
end