require 'spec_helper'
require_relative 'test_classes/name'

describe Name do
  it 'it has all accessors defined in xsd' do
    note = Name.new

    expect(note).to have_accessor :name
  end

  context 'validations are performed through validators on model itself' do
    it 'is valid with anything in name' do
      note = Name.new

      expect(note).to be_valid
    end

    it 'is valid with blank name' do
      note = Name.new(name: 'Premysl Donat')

      expect(note).to be_valid
    end
  end

  describe '#to_xml' do
    it "outputs model in xml valid by it's xsd" do
      note = Name.new(name: 'Premysl Donat')

      expect(note.to_xml).to eq File.read('./spec/xml/name.xml')
    end
  end

  describe '::from_xml' do
    it 'intializes new instance from given xml' do
      xml = File.read('./spec/xml/name.xml')
      note = Name.from_xml(xml)

      expect(note.name).to eq 'Premysl Donat'
    end
  end
end
