module XsdModel
  module Elements
    class Include
      include BaseElement
      #TODO: why isn't this picked up from BaseElement where it's also extended?
      extend AttributeMethods

      attribute_method 'schemaLocation'

      def load(options = {})
        xml_string = File.read(schema_location)

        schema = XsdModel.parse(xml_string, options).schema
        schema.source = schema_location
        schema
      end
    end
  end
end
