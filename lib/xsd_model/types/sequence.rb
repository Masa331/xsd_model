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
          elsif !elem['type'].nil? && elem['type'].start_with?('xs:')
            t = elem['type'].split(':').map(&:capitalize).join
            type_class = XsdModel::Types.const_get t
            type_class.new(elem).define_accessor(model)
          elsif !elem['type'].nil?
            t = elem['type']
            t[0] = t[0].upcase
            method_name = elem['name']

            parent_class = model.name.split('::').first
            element_class = model.const_get(parent_class).const_get(t)

            model.class_eval do
              define_method method_name do
                instance_variable_get("@#{method_name}") || element_class.new
              end

              define_method method_name + "=" do |value|
                instance_variable_set("@#{method_name}", value)
              end
            end
          else # Element
            t = elem.name
            t[0] = t[0].upcase

            type_class = XsdModel::Types.const_get t
            instance = type_class.new(elem)

            method_name = elem['name']

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

            instance.define_accessor(element_class)
          end
        end
      end
    end
  end
end
