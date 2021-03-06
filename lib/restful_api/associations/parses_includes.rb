require_relative 'reads_associations'

module RestfulApi
  module Associations
    class ParsesIncludes

      attr_reader :instance, :api

      def initialize(instance, api)
        @instance = instance
        @api      = api
      end

      def parse(associations)
        Hash[parse_includes(instance, [associations].flatten)]
      end

      private

      def parse_includes(instance, associations)
        associations.map! do |association|
          parse_include(instance, association)
        end
      end

      def parse_include(instance, association)
        if association.is_a? Hash
          name = association.keys.first
          options = association.values.first
          [name.to_s, read_association(instance, name, options)]
        else
          [association.to_s, read_association(instance, association)]
        end
      end

      def read_association(instance, association, options={})
        ReadsAssociations.new(self, association).read(options)
      end

    end
  end
end