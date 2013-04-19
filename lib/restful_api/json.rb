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

    private

    def include_root?
      Json.include_root_in_json
    end

    def include_root(attrs)
      if attrs.is_a? Array
        { resource_name.pluralize => attrs.map { |a| include_root(a) } }
      else
        { resource_name => attrs }
      end
    end

    def load(string)
      MultiJson.load(string)
    end

    def dump(object)
      object = yield(object) if block_given? and !yield.nil?
      MultiJson.dump(object)
    end

  end
end