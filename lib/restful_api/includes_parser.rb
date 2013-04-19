module RestfulApi
  module Associations
    class IncludesParser

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
        associations.map do |association|
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
        model = instance.send(association)

        if model.is_a? Array
          association_restful_api(model.class).read_collection(model, options)
        else
          association_restful_api(model.class).read_instance(model, options)
        end
      end

      def association_restful_api(klass)
        api.class.new(klass)
      end

    end
  end
end