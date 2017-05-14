module XsdModel
  module Types
    class Sequence
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.children

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              if elem['type'].start_with?('xs:')
                t = elem['type'].split(':').map(&:upcase_first).join

                "XsdModel::Types::#{t}".constantize
              else
                XsdModel::Types::UserType
              end
            else
              t = elem.name.upcase_first

              "XsdModel::Types::#{t}".constantize
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end
end
