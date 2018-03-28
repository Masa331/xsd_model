module XsdModel
  module Elements
    class Any
      include BaseElement

      def target_namespace
        attributes['targetNamespace'].value
      end
    end
  end
end
