require 'active_support/inflector'

module RestfulApi
  module Associations
    def self.included(base)
      base.class_eval do
        alias_method :read_instance_without_associations, :read_instance
        alias_method :read_instance, :read_instance_with_associations
      end
    end

    def read_instance_with_associations(id, options={})
      instance = read_instance_without_associations(id, options)

      if options[:include]
        instance.merge(associations(get_instance(id), options[:include]))
      else
        instance
      end
    end

    private

    def associations(instance, associations)
      associations.map! do |association|
        [association, read_association(instance, association)]
      end
      Hash[associations]
    end

    def read_association(instance, association)
      model = instance.send(association)

      if model.is_a? Array
        association_restful_api(association).read_collection(model)
      else
        association_restful_api(association).read_instance(model.id)
      end
    end

    def association_restful_api(association)
      self.class.new(association.to_s.classify.constantize)
    end
  end
end

class RestfulApi::Base
  include RestfulApi::Associations
end