require 'spec_helper'

RSpec.describe XsdModel::Elements::Include do
  describe '#load' do
    it 'loads linked schema' do
      incl = Include.new({ 'schemaLocation' => 'dependencies.xsd' })

      element = Element.new({ 'name' => 'name' })
      schema = Schema.new element, { 'targetNamespace' => 'dependencies.xsd' }

      expect(incl.load(ignore: :text)).to eq schema
    end
  end
end
