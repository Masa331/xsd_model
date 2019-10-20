require 'spec_helper'

RSpec.describe XsdModel::Elements::Schema do
  describe '#target_namespace' do
    it "returns schemas's targetNamespace" do
      schema = Schema.new(attributes: { 'targetNamespace' => 'http://namespace.com' })

      expect(schema.target_namespace).to eq 'http://namespace.com'
    end
  end

  describe '#has_target_namespace?' do
    it "returns true if schema has explicit targetNamespace" do
      schema = Schema.new(attributes: { 'targetNamespace' => 'http://namespace.com' })

      expect(schema.has_target_namespace?).to eq true
    end

    it "returns false if schema has no explicit targetNamespace" do
      schema = Schema.new

      expect(schema.has_target_namespace?).to eq false
    end
  end

  describe '#no_target_namespace?' do
    it "returns true if schema has no explicit targetNamespace" do
      schema = Schema.new(attributes: { 'targetNamespace' => 'http://namespace.com' })

      expect(schema.no_target_namespace?).to eq false
    end

    it "returns false if schema has explicit targetNamespace" do
      schema = Schema.new

      expect(schema.no_target_namespace?).to eq true
    end
  end

  describe '#collect_imported_schemas' do
    it 'recursivelly loads all linked schemas' do

      import = Import.new(attributes: { 'schemaLocation' => 'subschema.xsd' })
      schema = Schema.new(import)

      expected_element = Element.new(attributes: { 'name' => 'name' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })
      expected_import = Import.new(attributes: { 'schemaLocation' => 'dependencies.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_include = Include.new(attributes: { 'schemaLocation' => 'dependencies2.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_schemas = [Schema.new(expected_import, expected_include, attributes: { 'targetNamespace' => 'subschema.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" }),
                          Schema.new(expected_element, attributes: { 'targetNamespace' => 'dependencies.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })]

      expect(schema.collect_imported_schemas(ignore: :text)).to eq expected_schemas
    end
  end

  describe '#collect_included_schemas' do
    it 'recursivelly loads all linked schemas' do

      incl = Include.new(attributes: { 'schemaLocation' => 'subschema.xsd' })
      schema = Schema.new(incl)

      expected_element = Element.new(attributes: { 'name' => 'title' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })
      expected_import = Import.new(attributes: { 'schemaLocation' => 'dependencies.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_include = Include.new(attributes: { 'schemaLocation' => 'dependencies2.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )

      expected_schemas = [Schema.new(expected_import, expected_include, attributes: { 'targetNamespace' => 'subschema.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" }),
                          Schema.new(expected_element, attributes: { 'targetNamespace' => 'dependencies2.xsd' }, namespaces: { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })]

      expect(schema.collect_included_schemas(ignore: :text)).to eq expected_schemas
    end
  end
end
