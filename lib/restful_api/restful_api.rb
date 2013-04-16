require 'multi_json'

module RestfulApi
  class Base
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def create(attrs)
    end

    def read(id, options={})
      if id == :all
        read_all
      else
        read_instance(id, options)
      end
    end

    def read_collection(collection)
      collection.map { |instance| read_instance(instance.id) }
    end

    def read_instance(id, options={})
      to_hash(get_instance(id))
    end

    def update(id, attrs)
    end

    def destroy(id)
    end

    def json(id)
      MultiJson.dump(read(id))
    end

    private

    def read_all
      read_collection(get_all)
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

    def get_all
    end

    def get_first
    end

    def get_last
    end

    def get_id(id)
    end

    def to_hash(instance)
    end

  end
end