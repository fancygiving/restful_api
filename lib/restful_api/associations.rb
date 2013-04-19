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

    def read_instance_with_associations(instance, options={})
      attrs = read_instance_without_associations(instance, options)

      if options[:include]
        attrs.merge(associations(instance, options[:include]))
      else
        attrs
      end
    end

    def read_collection_with_associations(collection, options={})
      if options
        collection.map! do |instance|
          read_instance(instance, options)
        end
      else
        read_collection_without_associations(collection)
      end
    end

    private

    def associations(instance, associations)
      includes_parser(instance).parse(associations)
    end

    def includes_parser(instance)
      IncludesParser.new(instance, self)
    end

  end
end

class RestfulApi::Base
  include RestfulApi::Associations
end