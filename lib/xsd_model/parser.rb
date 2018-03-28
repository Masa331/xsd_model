require 'nokogiri'
require 'active_support/inflector'
require 'xsd_model/document_attributes'
require 'xsd_model/elements/requires'

module XsdModel
  class Parser
    using DocumentAttributes

    def self.call(xml_string, options = {})
      new(xml_string, options).call
    end

    def initialize(xml_string, options)
      @xml = Nokogiri(xml_string)
      @options = options
    end

    def call
      parse_node(@xml)
    end

    private

    def parse_node(node)
      klass = XsdModel::Elements.const_get node.name.camelize

      children = collect_children(node).map { |child| parse_node(child) }
      attributes = node.attributes.transform_values(&:value)
      namespaces = node.namespaces

      klass.new(children, attributes, namespaces)
    end

    def collect_children(node)
      skippable, collectible = node.children.partition do |child|
        (@options[:collect_only] && !@options[:collect_only].call(child)) ||
          (@options[:ignore] && @options[:ignore].call(child))
      end

      collectible + skippable.flat_map { |child| collect_children(child) }
    end
  end
end
