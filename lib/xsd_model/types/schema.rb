module XsdModel
  module Types
    class Schema
      attr_accessor :schema

      def initialize(schema)
        @schema = schema
      end

      def define_attributes(model)
        elems = schema.children

        elems.each do |elem|
          type_class =
            if !elem['type'].nil?
              t = elem['type'].split(':').map(&:capitalize).join

              XsdModel::Types.const_get t
            else
              t = elem.name
              t[0] = t[0].upcase

              XsdModel::Types.const_get t
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end
end
