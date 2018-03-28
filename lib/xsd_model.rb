require 'nokogiri'
require 'active_support/inflector'
# require_relative 'xsd_model/element_factory'
load Dir.pwd + '/lib/xsd_model/element_factory.rb'

module XsdModel
  def self.parse(xml_string, options = {})
    options = normalize_options(options)
    xml = Nokogiri::XML(xml_string)
    schema = xml.children.first

    # there can be more than one element at root(comment for example)
    elements = xml.children.map { |child| ElementFactory.call(child, options) }
    elements = filter_by_options(elements, options)

    schemas = elements.select { |element| element.is_a? Elements::Schema }

    (elements + schemas.map { |schema| collect_imported_schemas(schema) }).flatten
  end

  private

  def self.filter_by_options(elements, options)
    if options[:collect_only].any?
      elements = elements.select { |element| options[:collect_only].include? element.class }
    end

    if options[:ignore].any?
      elements = elements.reject { |element| options[:ignore].include? element.class }
    end

    elements
  end

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
    { collect_only: classify(options.fetch(:collect_only, [])),
      ignore: classify(options.fetch(:ignore, [])),
      skip_through: classify(options.fetch(:skip_through, []))
    }
  end

  def self.classify(option)
    [*option].map do |o|
      if o.is_a?(String) || o.is_a?(Symbol)
        Elements.const_get o.to_s.classify
      else
        o
      end
    end
  end
end
