require 'virtus'

require_relative 'mapper'

module RestfulApi
  module Client
    module Model

      def self.included(base)
        base.class_eval do
          include Virtus
        end

        base.extend ClassMethods
      end

      module ClassMethods
        def create(attrs)
          new(mapper.create(attrs))
        end

        def mapper
          Mapper.new(self)
        end
      end

      def save
        (self.attributes = mapper.create(attributes)) && true
      end

      def mapper
        self.class.mapper
      end
    end
  end
end