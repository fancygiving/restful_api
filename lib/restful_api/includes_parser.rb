module RestfulApi
  module Associations
    class IncludesParser

      attr_reader :instance, :api

      def initialize(instance, api)
        @instance = instance
        @api      = api
      end

      def parse(associations)
        associations = [associations] if associations.is_a? Symbol

        associations.map! do |association|
          parse_include(instance, association)
        end

        Hash[associations]
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
          association_restful_api(association).read_collection(model, options)
        else
          association_restful_api(association).read_instance(model.id, options)
        end
      end

      def association_restful_api(association)
        api.class.new(association.to_s.classify.constantize)
      end

    end
  end
end