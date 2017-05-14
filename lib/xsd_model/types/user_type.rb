module XsdModel
  module Types
    class UserType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        t = @schema['type'].upcase_first
        method_name = @schema['name']

        # parents is rails method and -2 is class before Object
        element_class = model.ancestors.first.parents[-2].const_get(t)

        model.class_eval do
          define_method method_name do
            instance_variable_get("@#{method_name}") || element_class.new
          end

          define_method method_name + "=" do |value|
            instance_variable_set("@#{method_name}", value)
          end
        end
      end
    end
  end
end
