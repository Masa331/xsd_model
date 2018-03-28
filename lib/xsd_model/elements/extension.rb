module XsdModel
  module Elements
    class Extension
      include BaseElement
      #TODO: why isn't this picked up from BaseElement where it's also extended?
      extend AttributeMethods

      attribute_method :base

      def basic_xsd_extension?
        base.start_with?("#{xsd_prefix}:")
      end

      def custom_extension?
        !basic_xsd_extension?
      end
    end
  end
end
