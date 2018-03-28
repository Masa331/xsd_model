module XsdModel
  module Elements
    class ComplexType
      include BaseElement
      #TODO: why isn't this picked up from BaseElement where it's also extended?
      extend AttributeMethods

      attribute_method :base
    end
  end
end
