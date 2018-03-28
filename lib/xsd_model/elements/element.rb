module XsdModel
  module Elements
    class Element
      include BaseElement

      def max_occurs
        value = attributes['maxOccurs']

        case value
        when 'unbounded'
          then Float::INFINITY
        when String
          then value.to_i
        when nil
          then 1
        end
      end

      def multiple?
        max_occurs > 1
      end
    end
  end
end
