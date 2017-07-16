module XsdModel
  module Types
    class Element
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

      def complex_element?
        true
      end
    end
  end
end
