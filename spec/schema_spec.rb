require 'spec_helper'

RSpec.describe XsdModel::Elements::Schema do
  describe '#target_namespace' do
    it "returns schemas's targetNamespace" do
      schema = Schema.new({ 'targetNamespace' => 'http://namespace.com' })

      expect(schema.target_namespace).to eq 'http://namespace.com'
    end
  end

  describe '#has_target_namespace?' do
    it "returns true if schema has explicit targetNamespace" do
      schema = Schema.new({ 'targetNamespace' => 'http://namespace.com' })

      expect(schema.has_target_namespace?).to eq true
    end

    it "returns false if schema has no explicit targetNamespace" do
      schema = Schema.new

      expect(schema.has_target_namespace?).to eq false
    end
  end

  describe '#no_target_namespace?' do
    it "returns true if schema has no explicit targetNamespace" do
      schema = Schema.new({ 'targetNamespace' => 'http://namespace.com' })

      expect(schema.no_target_namespace?).to eq false
    end

    it "returns false if schema has explicit targetNamespace" do
      schema = Schema.new

      expect(schema.no_target_namespace?).to eq true
    end
  end

  describe '#collect_imported_schemas' do
    it 'recursivelly loads all linked schemas' do

      import = Import.new({ 'schemaLocation' => 'subschema.xsd' })
      schema = Schema.new(import)

      expected_element = Element.new({ 'name' => 'name' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })
      expected_import = Import.new({ 'schemaLocation' => 'dependencies.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_include = Include.new({ 'schemaLocation' => 'dependencies2.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_schemas = [Schema.new(expected_import, expected_include, { 'targetNamespace' => 'subschema.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" }),
                          Schema.new(expected_element, { 'targetNamespace' => 'dependencies.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })]

      expect(schema.collect_imported_schemas(ignore: :text)).to eq expected_schemas
    end
  end

  describe '#collect_included_schemas' do
    it 'recursivelly loads all linked schemas' do

      incl = Include.new({ 'schemaLocation' => 'subschema.xsd' })
      schema = Schema.new(incl)

      expected_element = Element.new({ 'name' => 'title' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })
      expected_import = Import.new({ 'schemaLocation' => 'dependencies.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )
      expected_include = Include.new({ 'schemaLocation' => 'dependencies2.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" } )

      expected_schemas = [Schema.new(expected_import, expected_include, { 'targetNamespace' => 'subschema.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" }),
                          Schema.new(expected_element, { 'targetNamespace' => 'dependencies2.xsd' }, { "xmlns:xs"=>"http://www.w3.org/2001/XMLSchema" })]

      expect(schema.collect_included_schemas(ignore: :text)).to eq expected_schemas
    end
  end
end
