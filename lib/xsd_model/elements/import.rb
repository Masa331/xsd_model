module XsdModel
  module Elements
    class Import
      include BaseElement

      def namespace
        attributes['namespace'].value
      end

      #TODO: predat options/moznost stanovit options
      def load
        location = attributes['schemaLocation'].value
        xml_string = File.read(location)

        XsdModel.parse(xml_string).schema
      end
    end
  end
end
