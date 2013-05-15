module RestfulApi
  module Associations
    class ReadsAssociations
      attr_reader :association, :instance, :api

      def initialize(parser, association)
        @association  = association
        @instance     = parser.instance
        @api          = parser.api
      end

      def read(options)
        read_collection_or_instance(options)
      rescue RestfulApi::NotFoundError => e
        nil
      end

      private

      def read_collection_or_instance(options)
        if model.is_a? Array
          association_restful_api.read_collection(model, options)
        else
          association_restful_api.read_instance(model, options)
        end
      end

      def model
        @model ||= instance.send(association)
      end

      def association_restful_api
        api.class.new(model.class)
      end
    end
  end
end