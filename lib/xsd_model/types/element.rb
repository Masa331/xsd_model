module XsdModel
  module Types
    class Element
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        # require 'pry'; binding.pry
        # method_name = @schema['name']
        #
        # klass = Class.new do
        # end
        #
        # element_class = model.const_set(method_name + 'Type', klass)
        #
        # model.class_eval do
        #   define_method method_name do
        #     instance_variable_get("@#{method_name}") || element_class.new
        #   end
        #
        #   define_method method_name + "=" do |value|
        #     instance_variable_set("@#{method_name}", value)
        #   end
        # end

        elems = @schema.children
        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].split(':').map(&:capitalize).join

              # "XsdModel::Types::#{t}".constantize
              XsdModel::Types.const_get t
            else
              t = elem.name
              t[0] = t[0].upcase

              # "XsdModel::Types::#{t}".constantize
              XsdModel::Types.const_get t
            end

          type_class.new(elem).define_accessor(model)
        end
      end

      def complex_element?
        true
      end
    end
  end
end
