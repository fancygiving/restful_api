class MockModelRestfulApi < RestfulApi
  def create(attrs)
    resource.create(attrs)
  end

  def update(id, attrs)
    get(id).update(attrs)
  end

  def destroy(id)
    resource.delete(id)
  end

  private

  def read_all
    resource.all.map(&:to_h)
  end

  def read_first
    read_all.first
  end

  def read_last
    read_all.last
  end

  def read_id(id)
    get(id) && get(id).to_h
  end

  def get(id)
    resource.get(id)
  end

end