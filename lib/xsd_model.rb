require 'nokogiri'
require 'active_support/inflector'
require 'xsd_model/element_factory'

require 'xsd_model/elements/base_element'
require 'xsd_model/elements/import'
require 'xsd_model/elements/document'
require 'xsd_model/elements/max_length'
require 'xsd_model/elements/choice'
require 'xsd_model/elements/min_inclusive'
require 'xsd_model/elements/min_length'
require 'xsd_model/elements/comment'
require 'xsd_model/elements/any'
require 'xsd_model/elements/simple_content'
require 'xsd_model/elements/white_space'
require 'xsd_model/elements/extension'
require 'xsd_model/elements/sequence'
require 'xsd_model/elements/complex_content'
require 'xsd_model/elements/documentation'
require 'xsd_model/elements/any_attribute'
require 'xsd_model/elements/max_inclusive'
require 'xsd_model/elements/attribute'
require 'xsd_model/elements/complex_type'
require 'xsd_model/elements/pattern'
require 'xsd_model/elements/length'
require 'xsd_model/elements/annotation'
require 'xsd_model/elements/schema'
require 'xsd_model/elements/element'
require 'xsd_model/elements/union'
require 'xsd_model/elements/text'
require 'xsd_model/elements/base_element'
require 'xsd_model/elements/all'
require 'xsd_model/elements/enumeration'
require 'xsd_model/elements/group'
require 'xsd_model/elements/attribute_group'
require 'xsd_model/elements/restriction'
require 'xsd_model/elements/simple_type'

# load Dir.pwd + '/lib/dev.rb'

#TODO: turn into refinement
module Nokogiri
  module XML
    class Document
      def attributes
        attrs = {}

        attrs[:encoding] = encoding if encoding
        attrs[:version] = version if version

        attrs
      end
    end
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
    if options[:collect_only].any? && !options[:collect_only].include?(xml.name)
      return nil
    elsif options[:ignore].any? && options[:ignore].include?(xml.name)
      return nil
    else
      element = ElementFactory.call(xml, options)
      element.attributes = xml.attributes
      children = collect_children(xml, options)
      element.children = _parse children, options

      element
    end
  end

  def self.collect_children(xml, options)
    if options[:skip_through].any?

      skippable = xml.children.select { |child| options[:skip_through].include? child.name }
      children = xml.children.select { |child| !options[:skip_through].include? child.name }

      all = children + skippable.flat_map { |child| collect_children(child, options) }

      all
    else
      xml.children
    end
  end

  private

  def self.normalize_options(options)
    { collect_only: normalize_option(options[:collect_only]),
      ignore: normalize_option(options[:ignore]),
      skip_through: normalize_option(options[:skip_through])
    }
  end

  def self.normalize_option(option)
    case option
    when nil
      then []
    when String, Symbol
      then [option.to_s.singularize]
    when Array
      then option.map { |member| member.to_s.singularize.camelize(:lower) }
    else
      fail UnknownOptionType, 'Option given has to be either String, Symbol, Array, or nil.'
    end
  end
end
