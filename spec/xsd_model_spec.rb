require 'spec_helper'

RSpec.describe XsdModel do
  it 'parses empty schema' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
      </xs:schema>
    XSD

    text = Text.new
    schema = Schema.new([text])
    expected_document = Document.new(schema, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd)).to eq expected_document
  end

  it 'ignores nodes specified in :ignore options' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
      </xs:schema>
    XSD

    schema = Schema.new()
    expected_document = Document.new(schema, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd, ignore: :text)).to eq expected_document
  end

  it 'ignores nodes specified in :ignore options as a proc' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
      </xs:schema>
    XSD

    expected_document = Document.new(attributes: { "encoding"=>"UTF-8", "version"=>"1.0" })

    expect(XsdModel.parse(xsd, ignore: proc { true} )).to eq expected_document
  end

  it 'collects only nodes specified in :collect_only option' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="order" type="orderType"/>
      </xs:schema>
    XSD

    text1 = Text.new(namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"}, css_path: 'xs:schema > text():nth-of-type(1)')
    text2 = Text.new(namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"}, css_path: 'xs:schema > text():nth-of-type(2)')
    expected_document = Document.new(text1, text2, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd, collect_only: :text)).to eq expected_document
  end

  it 'collects only nodes specified in :collect_only as an array' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="order" type="orderType"/>
      </xs:schema>
    XSD

    text1 = Text.new(namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"}, css_path: 'xs:schema > text():nth-of-type(1)')
    text2 = Text.new(namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"}, css_path: 'xs:schema > text():nth-of-type(2)')
    schema = Schema.new(text1, text2, css_path: 'xs:schema')
    expected_document = Document.new(schema, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd, collect_only: [:schema, :text])).to eq expected_document
  end

  it 'parses schema with some element' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="name" type="xs:string"/>
        <xs:element name="order" type="orderType"/>
      </xs:schema>
    XSD

    name_element = Element.new(attributes: { "name" => 'name', 'type' => 'xs:string' }, namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"})
    order_element = Element.new(attributes: { "name" => 'order', 'type' => 'orderType' }, namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"})
    schema = Schema.new(name_element, order_element)
    expected_document = Document.new(schema, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd, ignore: :text)).to eq expected_document
  end

  it 'parses elements with plural names like totalDigits' do
    xsd = <<~XSD
      <?xml version="1.0" encoding="UTF-8"?>
      <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:totalDigits value="1">
        </xs:totalDigits>
      </xs:schema>
    XSD

    total_digits = TotalDigits.new(attributes: { "value" => '1' }, namespaces: {"xmlns:xs"=>"http://www.w3.org/2001/XMLSchema"})
    schema = Schema.new(total_digits)
    expected_document = Document.new(schema, attributes: {"encoding"=>"UTF-8", "version"=>"1.0"})

    expect(XsdModel.parse(xsd, ignore: :text)).to eq expected_document
  end
end
