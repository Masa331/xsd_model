require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

module XsdModel
  module ClassMethods
    def schema
      class_variable_get(:@@schema)
    end

    def from_xml(xml)
      new(name: 'Premysl Donat')
    end

    def build_with_xsd(path)
      file = File.open(path)
      class_variable_set(:@@schema, Nokogiri::XML(file))

      include_active_model
      define_accessors

      schema
    end

    def include_active_model
      include ActiveModel::Model
    end

    def define_accessors
      if root_element.key? 'type'
        define_accessor(root_element['name'])
      end
    end

    def define_accessor(name)
      attr_accessor name
    end

    def root_element
      schema.xpath('xs:schema/xs:element').first
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def schema
    self.class.schema
  end

  def to_xml
    doc = Nokogiri::XML::Document.new
    if self.class.root_element.key? 'type'
      node = Nokogiri::XML::Node.new(self.class.root_element['name'], doc)
      node.content = send(self.class.root_element['name'])

      doc << node
    end

    doc
  end
end
