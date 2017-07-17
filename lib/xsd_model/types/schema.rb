module XsdModel
  module Types
    class Schema
      attr_accessor :schema

      def initialize(schema)
        @schema = schema
      end

      def define_attributes(model)
        schema.children.each do |element|
          type_class = TypeClassResolver.call(element, model)

          type_class.new(element).define_accessor(model)
        end
      end
    end
  end
end
