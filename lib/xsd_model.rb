require 'xsd_model/version'
require 'nokogiri'

module XsdModel
  def build_with_xsd(path)
    file = File.open(path)
    @@schema = Nokogiri::XML(file)

    define_accessors

    schema
  end

  private

  def schema
    @@schema
  end

  def root_element
    schema.xpath('xs:schema/xs:element').first
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
