module XsdModel
  module Types
    class ComplexType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.children

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              # t = elem['type'].split(':').map(&:upcase_first).join
              t = elem['type'].split(':').map(&:capitalize).join

              # "XsdModel::Types::#{t}".constantize
              XsdModel::Types.const_get t
            else
              # t = elem.name.upcase_first
              t = elem.name
              t[0] = t[0].upcase

              # "XsdModel::Types::#{t}".constantize
              XsdModel::Types.const_get t
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end
end
