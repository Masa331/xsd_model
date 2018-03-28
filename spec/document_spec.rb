require 'spec_helper'

RSpec.describe XsdModel::Elements::Document do
  describe '#schema' do
    it "returns complex type's children elements" do
      schema = Schema.new
      document = Document.new schema, Text.new

      expect(document.schema).to eq schema
    end
  end

  describe '#reverse_traverse' do
    it 'traverses all the elements from the bottom up and yields element and block results from children' do
      element = Element.new
      schema = Schema.new element, element
      document = Document.new schema

      yields = [[element, []],
                [element, []],
                [schema, [nil, nil]],
                [document, [nil]]]

      expect { |b| document.reverse_traverse(&b) }.to yield_successive_args(*yields)
    end
  end
end
