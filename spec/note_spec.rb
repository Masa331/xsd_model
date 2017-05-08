require 'spec_helper'
require_relative 'test_classes/note'

describe Note do
  it 'it has all accessors defined in xsd' do
    note = Note.new

    expect(note).to have_accessor :to
    expect(note).to have_accessor :from
    expect(note).to have_accessor :heading
    expect(note).to have_accessor :body
  end

  context 'validations are performed through validators on model itself' do
    it 'is valid with anything in note' do
      note = Note.new

      expect(note).to be_valid
    end

    it 'is valid with blank note' do
      note = Note.new(to: 'Premysl Donat')

      expect(note).to be_valid
    end
  end

  describe '#to_xml' do
    it "outputs model in xml valid by it's xsd" do
      note = Note.new(to: 'Premysl Donat', from: 'Fred', heading: 'Hi!')

      expect(note.to_xml.to_xml).to eq File.read('./spec/xml/note.xml')
    end
  end

  describe '::from_xml' do
    it 'intializes new instance from given xml' do
      xml = File.read('./spec/xml/note.xml')
      note = Note.from_xml(xml)

      expect(note.to).to eq 'Premysl Donat'
      expect(note.from).to eq 'Fred'
      expect(note.heading).to eq 'Hi!'
      expect(note.body).to eq ""
    end
  end
end
