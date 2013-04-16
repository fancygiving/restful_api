class DataMapperRestfulApi < RestfulApi::Base
  def create(attrs)
    instance = resource.create(attrs)
    to_hash(instance)
  end

  def update(id, attrs)
    get_id(id).update(attrs)
    read(id)
  end

  def destroy(id)
    attrs = read(id)
    get_id(id).destroy
    attrs
  end

  private

  def to_hash(instance)
    instance && instance.attributes.stringify_keys
  end

  def get_all
    resource.all.to_a
  end

  def get_where(conditions)
    resource.all_with_virtual(conditions).to_a
  end

  def get_first
    resource.first
  end

  def get_last
    resource.last
  end

  def get_id(id)
    resource.get(id)
  end
end