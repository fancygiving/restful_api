module VirtualProperties
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def virtual_properties(*properties)
      @virtual_properties ||= properties
    end

    def all_with_virtual(conditions)
      virtual_conditions = remove_virtual_conditions(conditions)

      all(conditions).select do |instance|
        satisfies_conditions?(instance, virtual_conditions)
      end
    end

    def remove_virtual_conditions(conditions)
      conditions.select do |k,v|
        conditions.delete(k) if virtual_properties.include?(k)
      end
    end

    def satisfies_conditions?(instance, conditions)
      conditions.reduce(true) do |memo, (k, v)|
        memo = memo && (instance.send(k) == v)
      end
    end
  end

  def initialize(attributes={})
    super(remove_virtual_attributes(attributes))
  end

  def attributes_with_virtual
    attributes.merge(Hash[virtual_attributes])
  end

  private

  def virtual_attributes
    virtual_properties.map do |property|
      [property, send(property)]
    end
  end

  def remove_virtual_attributes(attributes)
    attributes.reject do |attribute|
      virtual_properties.include?(attribute.to_s) ||
      virtual_properties.include?(attribute.to_sym)
    end
  end

  def virtual_properties
    self.class.virtual_properties
  end
end