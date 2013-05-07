module RestfulApi
  class DataMapper < RestfulApi::Base
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
      if resource.respond_to?(:all_with_virtual)
        instance && instance.attributes_with_virtual.stringify_keys
      else
        instance && instance.attributes.stringify_keys
      end
    end

    def resource_name
      @resource_name ||= resource.name.underscore
    end

    def get_all
      resource.all.to_a
    end

    def get_where(conditions)
      if resource.respond_to?(:all_with_virtual)
        resource.all_with_virtual(conditions).to_a
      else
        resource.all(conditions).to_a
      end
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

    def build_instance
      resource.new(Hash[resource.properties.map { |r| [r.name, nil] }])
    end
  end
end