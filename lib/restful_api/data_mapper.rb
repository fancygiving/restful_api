module RestfulApi
  class DataMapper < RestfulApi::Base
    def create(attrs)
      read_instance(resource.create(attrs.symbolize_keys))
    rescue ArgumentError => e
      raise RestfulApi::InvalidAttributesError, e.message
    end

    def update(id, attrs)
      instance = get_id(id)

      if instance
        instance.update(attrs.symbolize_keys)
        read(id)
      else
        raise RestfulApi::NotFoundError, 'Resource not found'
      end
    rescue ArgumentError => e
      raise RestfulApi::InvalidAttributesError, e.message
    end

    def destroy(id)
      attrs = read(id)
      get_id(id).destroy
      attrs
    end

    def to_hash(instance)
      if resource.respond_to?(:all_with_virtual)
        instance && instance.attributes_with_virtual.stringify_keys
      else
        instance && instance.attributes.stringify_keys
      end
    end

    def get_all(options)
      get_where({}, options)
    end

    def get_where(conditions, options)
      conditions = conditions.merge(options.datamapper_options)

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
      resource.new(build_attributes)
    end

    private

    def resource_name
      @resource_name ||= resource.name.underscore
    end

    def build_attributes
      default_properties.merge(resource.new.attributes)
    end

    def default_properties
      Hash[resource.properties.map { |property| [property.name, nil] }]
    end
  end
end