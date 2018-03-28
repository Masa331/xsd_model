module XsdModel
  module Elements
    class Import
      include BaseElement
      #TODO: why isn't this picked up from BaseElement where it's also extended?
      extend AttributeMethods

      attribute_method :namespace, 'schemaLocation'

      def load(options = {})
        xml_string = File.read(schema_location)

        XsdModel.parse(xml_string, options).schema
      end
    end
  end
end
