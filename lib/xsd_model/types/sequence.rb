module XsdModel
  module Types
    class Sequence
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        @schema.children.each do |elem|
          if elem.text?
            next
          end

          type_class = TypeClassResolver.call(elem, model)

          element_class =
            if elem['type'].nil?
              klass = Class.new do
              end

              method_name = elem['name']
              element_class = model.const_set(method_name + 'Type', klass)
              model.class_eval do
                define_method method_name do
                  instance_variable_get("@#{method_name}") || element_class.new
                end

                define_method method_name + "=" do |value|
                  instance_variable_set("@#{method_name}", value)
                end
              end

              element_class
            else
              model
            end

          type_class.new(elem).define_accessor(element_class)
        end
      end
    end
  end
end
