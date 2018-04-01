module XsdModel
  module Elements
    class Import
      include BaseElement

      def namespace
        attributes['namespace']
      end

      def schema_location
        attributes['schemaLocation']
      end

      #TODO: predat options/moznost stanovit options
      def load(options)
        location = schema_location
        xml_string = File.read(location)

        XsdModel.parse(xml_string, options).schema
      end
    end
  end
end
