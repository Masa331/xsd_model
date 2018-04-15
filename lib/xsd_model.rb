require 'nokogiri'
require 'active_support/inflector'
require 'xsd_model/element_factory'

require 'xsd_model/elements/base_element'

require 'xsd_model/elements/import'
require 'xsd_model/elements/document'
require 'xsd_model/elements/max_length'
require 'xsd_model/elements/choice'
require 'xsd_model/elements/logical'
require 'xsd_model/elements/min_inclusive'
require 'xsd_model/elements/min_length'
require 'xsd_model/elements/content'
require 'xsd_model/elements/comment'
require 'xsd_model/elements/any'
require 'xsd_model/elements/min_exclusive'
require 'xsd_model/elements/simple_content'
require 'xsd_model/elements/white_space'
require 'xsd_model/elements/extension'
require 'xsd_model/elements/sequence'
require 'xsd_model/elements/complex_content'
require 'xsd_model/elements/documentation'
require 'xsd_model/elements/doctype'
require 'xsd_model/elements/any_attribute'
require 'xsd_model/elements/max_inclusive'
require 'xsd_model/elements/attribute'
require 'xsd_model/elements/complex_type'
require 'xsd_model/elements/include'
require 'xsd_model/elements/schema_info'
require 'xsd_model/elements/pattern'
require 'xsd_model/elements/length'
require 'xsd_model/elements/annotation'
require 'xsd_model/elements/schema'
require 'xsd_model/elements/element'
require 'xsd_model/elements/fraction_digits'
require 'xsd_model/elements/union'
require 'xsd_model/elements/text'
require 'xsd_model/elements/total_digits'
require 'xsd_model/elements/all'
require 'xsd_model/elements/appinfo'
require 'xsd_model/elements/enumeration'
require 'xsd_model/elements/group'
require 'xsd_model/elements/collection'
require 'xsd_model/elements/attribute_group'
require 'xsd_model/elements/restriction'
require 'xsd_model/elements/simple_type'

# load Dir.pwd + '/lib/dev.rb'

#TODO: turn into refinement
module Nokogiri
  module XML
    class Document
      FakeAttr = Struct.new(:name, :value)

      def attributes
        attrs = {}

        attrs['encoding'] = FakeAttr.new('encoding', encoding) if encoding
        attrs['version'] = FakeAttr.new('version', version) if version

        attrs
      end
    end
  end
end

#TODO: turn into refinement
class String
  def xsdize
    camelize(:lower)
  end
end
#TODO: turn into refinement
class Symbol
  def xsdize
    to_s.camelize(:lower)
  end
end

module XsdModel
  class UnknownOptionType < StandardError; end

  def self.parse(xml_string, options = {})
    options = normalize_options(options)
    xml = Nokogiri::XML(xml_string)

    _parse(xml, options)
  end

  def self._parse(xml, options)
    if xml.is_a?(Array) || xml.is_a?(Nokogiri::XML::NodeSet)
      parse_multiple(xml, options)
    else
      parse_one(xml, options)
    end
  end

  def self.parse_multiple(xmls, options)
    xmls.map { |child| _parse(child, options) }.compact
  end

  def self.parse_one(xml, options)
    ElementFactory.call(xml) do |element|
      children = collect_children(xml, options)
      element.children = _parse children, options
    end
  end

  def self.collect_children(xml, options)
    skippable, collectible = xml.children.partition do |child|
      (options[:collect_only] && !options[:collect_only].call(child)) ||
        (options[:ignore] && options[:ignore].call(child))
    end

    collectible + skippable.flat_map { |child| collect_children(child, options) }
  end

  private

  def self.normalize_options(options)
    options.transform_values do |value|
      case value
      when Proc
        then value
      when String, Symbol
        then -> (child) { [value.xsdize].include? child.name }
      when Array
        then -> (child) { value.map(&:xsdize).include? child.name }
      else
        fail UnknownOptionType, 'Option given has to be either String, Symbol, Array, or Proc.'
      end
    end
  end
end
