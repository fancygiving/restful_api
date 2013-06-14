class MockModelRestfulApi < RestfulApi::Base
  def create(attrs)
    read_instance(resource.create(attrs))
  end

  def update(id, attrs)
    instance = get_id(id)
    if instance
      instance.update_attributes(attrs)
      read_instance(instance)
    else
      raise RestfulApi::NotFoundError, 'Resource not found'
    end
  end

  def destroy(id)
    attrs = read(id)
    get_id(id).destroy
    attrs
  end

  def to_hash(instance)
    instance && instance.to_h.stringify_keys
  end

  def resource_name
    @resource_name ||= resource.model_name.underscore
  end

  def get_all(offset=nil, limit=nil)
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

  def build_instance
    resource.new(Hash[resource.attributes.map { |r| [r, nil] }])
  end

end