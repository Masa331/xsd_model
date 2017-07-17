module XsdModel
  module Types
    class Sequence
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        @schema.children.each do |element|
          if element.text?
            next
          end

          type_class = TypeClassResolver.call(element, model)

          element_class =
            if element['type'].nil?
              klass = Class.new do
              end

              method_name = element['name']
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

          type_class.new(element).define_accessor(element_class)
        end
      end
    end
  end
end
