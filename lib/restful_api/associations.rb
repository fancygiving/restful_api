require 'active_support/inflector'
require 'active_support/core_ext/hash'
require_relative 'includes_parser'

module RestfulApi
  module Associations

    def self.included(base)
      base.class_eval do
        alias_method :read_instance_without_associations, :read_instance
        alias_method :read_instance, :read_instance_with_associations

        alias_method :read_collection_without_associations, :read_collection
        alias_method :read_collection, :read_collection_with_associations
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

    def read_collection_with_associations(collection, options={})
      if options
        collection.map do |instance|
          read_instance(instance.id, options)
        end
      else
        read_collection_without_associations(collection)
      end
    end

    private

    def associations(instance, associations)
      IncludesParser.new(instance, self).parse(associations)
    end

  end
end

class RestfulApi::Base
  include RestfulApi::Associations
end