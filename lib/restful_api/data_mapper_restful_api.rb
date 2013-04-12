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