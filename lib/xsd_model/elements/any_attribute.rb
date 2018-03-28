module XsdModel
  module Elements
    class AnyAttribute
      include BaseElement

      def target_namespace
        attributes['targetNamespace'].value
      end
    end
  end
end
