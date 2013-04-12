class MockModelRestfulApi < RestfulApi
  def create(attrs)
    resource.create(attrs)
  end

  def update(id, attrs)
    get_id(id).update(attrs)
  end

  def destroy(id)
    resource.delete(id)
  end

  private

  def to_hash(instance)
    instance && instance.to_h
  end

  def get_all
    resource.all
  end

  def get_first
    get_all.first
  end

  def get_last
    get_all.last
  end

  def get_id(id)
    resource.get(id)
  end

end