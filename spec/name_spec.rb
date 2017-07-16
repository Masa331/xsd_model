require 'spec_helper'
require_relative 'test_classes/name'

describe Name do
  it 'it has all accessors defined in xsd' do
    name = Name.new

    expect(name).to have_accessor :name
  end

  xcontext 'validations are performed through validators on model itself' do
    it 'is valid with anything in name' do
      name = Name.new

      expect(name).to be_valid
    end

    it 'is valid with blank name' do
      name = Name.new(name: 'Premysl Donat')

      expect(name).to be_valid
    end
  end

  xdescribe '#to_xml' do
    it "outputs model in xml valid by it's xsd" do
      name = Name.new(name: 'Premysl Donat')

      expect(name.to_xml.to_xml).to eq File.read('./spec/xml/name.xml')
    end
  end

  xdescribe '::from_xml' do
    it 'intializes new instance from given xml' do
      xml = File.read('./spec/xml/name.xml')
      name = Name.from_xml(xml)

      expect(name.name).to eq 'Premysl Donat'
    end
  end
end
