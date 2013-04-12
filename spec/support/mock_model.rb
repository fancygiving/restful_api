class MockModel
  @collection = []

  class << self
    def collection=(collection)
      @collection = collection
    end

    def get(id)
      @collection.find { |item| item[:id] == id }
    end

    def all
      @collection
    end

    def create(attrs)
      @collection << attrs.merge({id: next_id})
    end

    def delete(id)
      @collection.reject! { |item| item[:id] == id }
    end

    def next_id
      @collection.map { |item| item[:id].to_i }.max + 1
    end
  end
end