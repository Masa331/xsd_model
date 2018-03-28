module XsdModel
  module Xsdize
    refine String do
      def xsdize
        camelize(:lower)
      end
    end

    refine Symbol do
      def xsdize
        to_s.camelize(:lower)
      end

      def camelize
        to_s.camelize
      end

      def underscore
        to_s.underscore
      end
    end
  end
end
