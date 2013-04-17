require 'multi_json'

module RestfulApi
  module Json

    def create(attrs)
      dump(super(load(attrs)))
    end

    def read(id, options={})
      dump(super(id, options))
    end

    def update(id, attrs)
      super(id, load(attrs))
    end

    def destroy(id)
      super(id)
    end

    private

    def load(string)
      MultiJson.load(string)
    end

    def dump(object)
      MultiJson.dump(object)
    end

  end
end