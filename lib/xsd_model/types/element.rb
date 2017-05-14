module XsdModel
  module Types
    class Element
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        method_name = @schema['name']

        klass = Class.new do
        end

        element_class = model.const_set(method_name + 'Type', klass)

        model.class_eval do
          define_method method_name do
            instance_variable_get("@#{method_name}") || element_class.new
          end

          define_method method_name + "=" do |value|
            instance_variable_set("@#{method_name}", value)
          end
        end

        elems = @schema.children
        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].split(':').map(&:upcase_first).join

              "XsdModel::Types::#{t}".constantize
            else
              t = elem.name.upcase_first

              "XsdModel::Types::#{t}".constantize
            end

          type_class.new(elem).define_accessor(element_class)
        end
      end
    end
  end
end
