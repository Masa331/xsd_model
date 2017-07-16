module XsdModel
  module Types
    class ComplexType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.children

        elems.each do |elem|
          type_class = TypeClassResolver.call(elem, model)

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end
end
