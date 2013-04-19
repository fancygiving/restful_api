class MockModelRestfulApi < RestfulApi::Base
  def create(attrs)
    read_instance(resource.create(attrs))
  end

  def update(id, attrs)
    instance = get_id(id)
    instance.update_attributes(attrs)
    read_instance(instance)
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

  def resource_name
    @resource_name ||= resource.model_name.underscore
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