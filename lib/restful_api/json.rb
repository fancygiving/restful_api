require 'multi_json'

module RestfulApi
  module Json

    def self.include_root_in_json=(boolean=false)
      @include_root_in_json = boolean
    end

    def self.include_root_in_json
      @include_root_in_json
    end

    def create(attrs)
      super(load(attrs))
    end

    def read_collection(collection, options={})
      json = "[#{super.join(',')}]"
      json = "{\"#{resource_name.pluralize}\":#{json}}" if include_root?
      json
    end

    def read_instance(instance, options={})
      json = dump(super)
      json = "{\"#{resource_name}\":#{json}}" if include_root?
      json
    end

    def update(id, attrs)
      super(id, load(attrs))
    end

    def destroy(id)
      super(id)
    end

    def include_root?
      Json.include_root_in_json
    end

    def load(object)
      if object.is_a? String
        MultiJson.load(object)
      else
        object
      end
    end

    def dump(object)
      object = yield(object) if block_given? and !yield.nil?
      MultiJson.dump(object)
    end

  end
end