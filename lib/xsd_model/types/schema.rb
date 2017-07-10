module XsdModel
  module Types
    class Schema
      attr_accessor :schema

      def initialize(schema)
        @schema = schema
      end

      def define_attributes(model)
        elems = schema.children.presence || [schema]

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].split(':').map(&:upcase_first).join

              XsdModel::Types.const_get t
            else
              t = elem.name.upcase_first

              XsdModel::Types.const_get t
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end
end
