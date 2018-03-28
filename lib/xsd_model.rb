require 'xsd_model/parser'
require 'xsd_model/xsdize'

module XsdModel
  class UnknownOptionType < StandardError; end

  using Xsdize

  def self.parse(xml_string, options = {})
    Parser.call(xml_string, normalize_options(options))
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
