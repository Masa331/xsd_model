require 'spec_helper'

RSpec.describe XsdModel::Elements::ComplexType do
  describe '#elements' do
    it "returns complex type's children elements" do
      element = Element.new
      complex_type = ComplexType.new element, Text.new

      expect(complex_type.elements).to eq [element]
    end
  end
end
