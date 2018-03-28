module XsdModel
  module Elements
    class AttributeGroup
      include BaseElement

      def target_namespace
        attributes['targetNamespace'].value
      end
    end
  end
end
