module XsdModel
  module Elements
    class Import
      include BaseElement

      def namespace
        attributes['namespace'].value
      end

      def schema_location
        attributes['schemaLocation'].value
      end

      #TODO: predat options/moznost stanovit options
      def load
        location = schema_location
        xml_string = File.read(location)

        XsdModel.parse(xml_string).schema
      end
    end
  end
end
