class MockModelRestfulApi < RestfulApi
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