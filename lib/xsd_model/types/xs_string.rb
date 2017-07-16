module XsdModel
  module Types
    class XsString
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        name = @schema['name']

        model.class_eval do
          attr_accessor name
        end
      end

      def complex_element?
        false
      end
    end
  end
end
