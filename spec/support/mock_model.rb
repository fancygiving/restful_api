class MockModel
  class << self
    def reset!
      @collection = []
      @next_id    = 0
    end

    def collection=(collection)
      @collection = collection
    end

    def get(id)
      @collection.find { |item| item.id == id }
    end

    def all
      @collection
    end

    def create(attrs)
      @next_id += 1
      @collection << new(attrs.merge(id: @next_id))
    end

    def delete(id)
      @collection.reject! { |item| item.id == id }
    end
  end

  attr_reader :attributes

  def initialize(attrs)
    @attributes = attrs
  end

  def id
    attributes[:id]
  end

  def name
    attributes[:name]
  end

  def update(attrs)
    attributes.merge!(attrs)
  end

  def to_h
    Hash[attributes.sort]
  end

  def to_json(options)
    MultiJson.dump(to_h)
  end

end