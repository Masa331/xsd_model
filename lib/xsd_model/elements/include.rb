module XsdModel
  module Elements
    class Include
      include BaseElement

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
