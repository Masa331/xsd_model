require 'nokogiri'
require 'active_support/inflector'
# require_relative 'xsd_model/element_factory'
load Dir.pwd + '/lib/xsd_model/element_factory.rb'

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

  def self.collect_imported_schemas(original_schema, already_collected = [])
    imports = original_schema.imports

    imports.each do |import|
      unless already_collected.map(&:target_namespace).include? import.namespace
        new_schema = import.load
        already_collected << new_schema
        collect_imported_schemas(new_schema, already_collected)
      end
    end

    already_collected
  end

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
