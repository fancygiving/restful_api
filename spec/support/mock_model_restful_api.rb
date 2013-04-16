class MockModelRestfulApi < RestfulApi::Base
  def create(attrs)
    instance = resource.create(attrs)
    to_hash(instance)
  end

  def update(id, attrs)
    get_id(id).update_attributes(attrs)
    read(id)
  end

  def destroy(id)
    attrs = read(id)
    get_id(id).destroy
    attrs
  end

  private

  def to_hash(instance)
    instance && instance.to_h.stringify_keys
  end

  def get_all
    resource.all
  end

  def get_where(conditions)
    collection = get_all

    conditions.each do |k, v|
      collection.select! do |instance|
        instance.send(k) == v
      end
    end

    collection
  end

  def get_first
    get_all.first
  end

  def get_last
    get_all.last
  end

  def get_id(id)
    resource.find(id)
  rescue SuperModel::UnknownRecord
    nil
  end

end