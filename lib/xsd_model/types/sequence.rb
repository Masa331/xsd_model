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
          elsif elem['type'].present? && elem['type'].start_with?('xs:')
            t = elem['type'].split(':').map(&:capitalize).join
            type_class = XsdModel::Types.const_get t
            type_class.new(elem).define_accessor(model)
          elsif elem['type'].present?
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

      # def define_accessor(model)
      #   elems = @schema.children
      #
      #   elems.each do |elem|
      #     type_class =
      #       if elem['type'].present?
      #         if elem['type'].start_with?('xs:')
      #           t = elem['type'].split(':').map(&:capitalize).join
      #
      #           XsdModel::Types.const_get t
      #         else
      #           # XsdModel::Types::UserType
      #
      #           t = elem['type']
      #           t[0] = t[0].upcase
      #           method_name = elem['name']
      #
      #           parent_class = model.name.split('::').first
      #           element_class = model.const_get(parent_class).const_get(t)
      #
      #           model.class_eval do
      #             define_method method_name do
      #               instance_variable_get("@#{method_name}") || element_class.new
      #             end
      #
      #             define_method method_name + "=" do |value|
      #               instance_variable_set("@#{method_name}", value)
      #             end
      #           end
      #         end
      #       else
      #         t = elem.name
      #         t[0] = t[0].upcase
      #
      #         XsdModel::Types.const_get t
      #       end
      #
      #     # if type_class == :Address
      #       require 'pry'; binding.pry
      #     # end
      #     inst = type_class.new(elem)
      #     new_model =
      #       if inst.complex_element?
      #         method_name = elem['name']
      #
      #         klass = Class.new do
      #         end
      #
      #         element_class = model.const_set(method_name + 'Type', klass)
      #
      #         model.class_eval do
      #           define_method method_name do
      #             instance_variable_get("@#{method_name}") || element_class.new
      #           end
      #
      #           define_method method_name + "=" do |value|
      #             instance_variable_set("@#{method_name}", value)
      #           end
      #         end
      #
      #         element_class
      #       else
      #         model
      #       end
      #
      #     inst.define_accessor(new_model)
      #   end
      # end
