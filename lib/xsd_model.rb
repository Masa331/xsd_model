require 'xsd_model/version'
require 'nokogiri'

require_relative 'xsd_model/types'
require_relative 'xsd_model/type_class_resolver'

module XsdModel
  module Model
    module ClassMethods
      def build_with_xsd(path)
        file = File.open(path)
        xsd = Nokogiri::XML(file)
        root_element_schema = Types::Schema.new(xsd.xpath('xs:schema').first)

        class_variable_set(:@@schema, xsd)

        root_element_schema.define_attributes(self)

        schema
      end

      def schema
        class_variable_get(:@@schema)
      end

      def const_missing(name)
        find_in_schema(name) || super
      end

      private

      def find_in_schema(name)
        find_named_complex_type(name) || find_group(name)
      end

      def find_named_complex_type(name)
        type_root = schema.xpath("xs:schema/xs:complexType[@name='#{name}']")

        return nil unless type_root.any?

        constant = Class.new
        Types::Schema.new(type_root).define_attributes(constant)
        self.const_set(name, constant)
      end

      def find_group(name)
        type_root = schema.xpath("xs:schema/xs:group[@name='#{name}']")

        return nil unless type_root.any?

        constant = Module.new
        Types::Schema.new(type_root).define_attributes(constant)
        self.const_set(name, constant)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
