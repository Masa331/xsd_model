require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

module XsdModel
  module ClassMethods
    def build_with_xsd(path)
      file = File.open(path)
      class_variable_set(:@@schema, Nokogiri::XML(file))

      include_active_model
      define_attributes

      schema
    end

    def schema
      class_variable_get(:@@schema)
    end

    def from_xml(xml)
      instance = new
      doc = Nokogiri::XML(xml)

      doc.children.each do |child|
        if child.children.all? &:text?
          type = schema%"//*[@name='#{child.name}']"

          case type['type']
          when 'xs:string'
            instance.send("#{child.name}=", child.text)
          when 'xs:date'
            instance.send("#{child.name}=", Date.parse(child.text))
          end
        else
          child.children.select(&:element?).each do |element|
            instance.send("#{element.name}=", element.text)
          end
        end
      end

      instance
    end

    def include_active_model
      include ActiveModel::Model
    end

    def define_attributes
      if root_element.key? 'type'
        define_accessor(root_element['name'])

        case root_element['type']
        when 'xs:date'
          validates root_element['name'],
            presence: true
        when 'xs:string'
          nil
        end
      elsif root_element%'//xs:complexType/xs:sequence'
        seq = root_element%'//xs:complexType/xs:sequence'
        seq.children.select(&:element?).each do |element|
          define_accessor(element['name'])
        end
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
    elsif self.class.root_element%'//xs:complexType/xs:sequence'
      seq_elements = self.class.root_element%'//xs:complexType/xs:sequence'

      root = Nokogiri::XML::Node.new(self.class.root_element['name'], doc)
      doc << root

      seq_elements.children.select(&:element?).each do |element|
        node = Nokogiri::XML::Node.new(element['name'], doc)
        node.content = send(element['name'])

        root << node
      end
    end

    doc
  end
end
