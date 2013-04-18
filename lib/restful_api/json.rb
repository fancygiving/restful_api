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
      dump(super(load(attrs)))
    end

    def read(id, options={})
      dump(super(id, options)) do |attrs|
        include_root(attrs) if ::RestfulApi::Json.include_root_in_json
      end
    end

    def update(id, attrs)
      super(id, load(attrs))
    end

    def destroy(id)
      super(id)
    end

    private

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