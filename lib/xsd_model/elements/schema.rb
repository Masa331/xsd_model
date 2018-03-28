module XsdModel
  module Elements
    class Schema
      include BaseElement

      def target_namespace
        attributes['targetNamespace'].value
      end
    end
  end
end
