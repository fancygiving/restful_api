module RestfulApi
  class NotFoundError < StandardError; end
  class InvalidAttributesError < StandardError; end

  class Base
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def create(attrs)
    end

    def build
      read_instance(build_instance)
    end

    def read(id, options={})
      if id.is_a? Hash
        read_where(id, options)
      elsif id == :all
        read_all(options)
      else
        read_instance(get_instance(id), options)
      end
    end

    def read_collection(collection, options={})
      collection.map! { |instance| read_instance(instance) }
    end

    def read_instance(instance, options={})
      raise RestfulApi::NotFoundError, 'Resource not found' unless instance.present?
      to_hash(instance)
    end

    def update(id, attrs)
    end

    def destroy(id)
    end

    def read_all(options={})
      offset, limit = offset_and_limit(options[:page], options[:per_page])
      read_collection(get_all(offset, limit), options)
    end

    def read_where(conditions, options={})
      offset, limit = offset_and_limit(options[:page], options[:per_page])
      read_collection(get_where(conditions, offset, limit), options)
    end

    def get_instance(id)
      if id == :first
        get_first
      elsif id == :last
        get_last
      else
        get_id(id)
      end
    end

    def get_all(offset, limit)
    end

    def get_first
    end

    def get_last
    end

    def get_id(id)
    end

    def to_hash(instance)
    end

    def offset_and_limit(page, per_page)
      if page && per_page
        [page.to_i * per_page.to_i, per_page.to_i]
      else
        [nil, nil]
      end
    end

  end
end