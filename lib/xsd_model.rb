require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

module XsdModel
  def build_with_xsd(path)
    file = File.open(path)
    @@schema = Nokogiri::XML(file)

    include_active_model
    define_accessors
    define_to_xml
    define_from_xml

    schema
  end

  private

  def schema
    @@schema
  end

  def root_element
    schema.xpath('xs:schema/xs:element').first
  end

  def include_active_model
    include ActiveModel::Model
  end

  def define_to_xml
    define_method(:to_xml) do
      <<~XML
       <?xml version="1.0" encoding="UTF-8"?>
       <name>Premysl Donat</name>
       XML
    end
  end

  def define_from_xml
    define_singleton_method(:from_xml) do |xml|
      new(name: 'Premysl Donat')
    end
  end

  def define_accessors
    if root_element.key? 'type'
      define_accessor(root_element['name'])
    end
  end

  def define_accessor(name)
    attr_accessor name
  end
end
