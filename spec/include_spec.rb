require 'spec_helper'

RSpec.describe XsdModel::Elements::Include do
  describe '#load' do
    it 'loads linked schema' do
      incl = Include.new(attributes: { 'schemaLocation' => 'dependencies.xsd' })

      element = Element.new(attributes: { 'name' => 'name' }, css_path: 'xs:schema > xs:element')
      schema = Schema.new element, attributes: { 'targetNamespace' => 'dependencies.xsd' }, css_path: 'xs:schema'

      expect(incl.load(ignore: :text)).to eq schema
    end
  end
end
