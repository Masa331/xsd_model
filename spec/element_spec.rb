require 'spec_helper'

RSpec.describe XsdModel::Elements::Element do
  describe '#name' do
    it "returns element's name" do
      element = Element.new({ 'name' => 'order' })

      expect(element.name).to eq 'order'
    end
  end

  describe '#type' do
    it "returns element's type" do
      element = Element.new({ 'type' => 'xs:string' })

      expect(element.type).to eq 'xs:string'
    end
  end

  describe '#has_type?' do
    it "returns true if element has explicit type" do
      element = Element.new({ 'type' => 'xs:string' })

      expect(element.has_type?).to eq true
    end

    it "returns false if element has no explicit type" do
      element = Element.new

      expect(element.has_type?).to eq false
    end
  end

  describe '#no_type?' do
    it "returns true if element has no explicit type" do
      element = Element.new({ 'type' => 'xs:string' })

      expect(element.no_type?).to eq false
    end

    it "returns false if element has explicit type" do
      element = Element.new

      expect(element.no_type?).to eq true
    end
  end

  describe '#xsd_prefix' do
    it 'returns prefix associated with http://www.w3.org/2001/XMLSchema namespace' do
      element = Element.new({}, { 'xs' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.xsd_prefix).to eq 'xs'

      element = Element.new({}, { 'xsd' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.xsd_prefix).to eq 'xsd'
    end
  end

  describe '#has_custom_type?' do
    it "returns true if element's type is custom defined one" do
      element = Element.new({ 'type' => 'orderType' }, { 'xs' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.has_custom_type?).to eq true
    end

    it "returns false if element's type is one of basic XSD types" do
      element = Element.new({ 'type' => 'xs:string' }, { 'xs' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.has_custom_type?).to eq false
    end

    it "returns false if element has no type set" do
      element = Element.new
      expect(element.has_custom_type?).to eq false
    end
  end

  describe '#basic_xsd_type?' do
    it "returns true if element's type is one of basic XSD types" do
      element = Element.new({ 'type' => 'xs:string' }, { 'xs' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.basic_xsd_type?).to eq true
    end

    it "returns false if element's type is custom defined one" do
      element = Element.new({ 'type' => 'orderType' }, { 'xs' => 'http://www.w3.org/2001/XMLSchema' })
      expect(element.basic_xsd_type?).to eq false
    end

    it "returns false if element has no type set" do
      element = Element.new
      expect(element.basic_xsd_type?).to eq false
    end
  end

  describe '#empty?' do
    it 'returns true if element has no children' do
      element = Element.new []
      expect(element.empty?).to eq true
    end
  end

  describe '==' do
    it 'returns true if elements attributes and childrens match' do
      element1 = Element.new(Text.new, { 'key' => 'value' })
      element2 = Element.new(Text.new, { 'key' => 'value' })

      expect(element1).to eq element2
    end
  end

  describe '==' do
    it "returns false if elements attributes don't match" do
      element1 = Element.new(Text.new, { 'key' => 'value' })
      element2 = Element.new(Text.new, { 'key' => 'other_value' })

      expect(element1).not_to eq element2
    end
  end

  describe '==' do
    it "returns false if elements attributes don't match" do
      element1 = Element.new(Text.new, { 'key' => 'value' })
      element2 = Element.new(Text.new, Text.new, { 'key' => 'value' })

      expect(element1).not_to eq element2
    end
  end

  describe '#total_digits' do
    it 'returns all children which are TotalDigits' do
      total_digits = TotalDigits.new
      element = Element.new(total_digits, Text.new)

      expect(element.total_digits).to eq [total_digits]
    end
  end

  describe '#max_occurs' do
    it 'returns 1 if element has no maxOccurs' do
      element = Element.new

      expect(element.max_occurs).to eq 1
    end

    it "returns value from maxOccurs if it's set" do
      element = Element.new({ 'maxOccurs' => '4' })

      expect(element.max_occurs).to eq 4
    end

    it "returns Infinity if maxOccurs is set to 'unbounded'" do
      element = Element.new({ 'maxOccurs' => 'unbounded' })

      expect(element.max_occurs).to eq Float::INFINITY
    end
  end

  describe '#multiple?' do
    it "returns true if element's maxOccurs is bigger than 1" do
      element = Element.new({ 'maxOccurs' => '2' })

      expect(element.multiple?).to eq true
    end

    it "returns false if element's maxOccurs is 1" do
      element = Element.new({ 'maxOccurs' => '1' })

      expect(element.multiple?).to eq false
    end

    it "returns false if element's maxOccurs is not set" do
      element = Element.new

      expect(element.multiple?).to eq false
    end

    it "returns true if element's maxOccurs is set to infinity" do
      element = Element.new({ 'maxOccurs' => 'unbounded' })

      expect(element.multiple?).to eq true
    end
  end
end
