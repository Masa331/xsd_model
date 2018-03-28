module XsdModel
  module DocumentAttributes
    FakeAttr = Struct.new(:name, :value)

    refine Nokogiri::XML::Document do
      def attributes
        attrs = {}

        attrs['encoding'] = FakeAttr.new('encoding', encoding) if encoding
        attrs['version'] = FakeAttr.new('version', version) if version

        attrs
      end
    end
  end
end
