require 'spec_helper'

RSpec.describe XsdModel::Elements::Import do
  describe '#load' do
    it 'loads linked schema' do
      import = Import.new(attributes: { 'schemaLocation' => 'dependencies.xsd' })

      element = Element.new(attributes: { 'name' => 'name' })
      schema = Schema.new element, attributes: { 'targetNamespace' => 'dependencies.xsd' }

      expect(import.load(ignore: :text)).to eq schema
    end
  end
end
