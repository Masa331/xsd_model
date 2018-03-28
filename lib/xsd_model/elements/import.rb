module XsdModel
  module Elements
    class Import
      include BaseElement

      def namespace
        attributes['namespace'].value
      end

      def load
        location = attributes['schemaLocation'].value
        xml_string = File.read(location)

        xml = Nokogiri::XML(xml_string)
        schema = xml.children.first

        ElementFactory.call(schema)
      end
    end
  end
end
