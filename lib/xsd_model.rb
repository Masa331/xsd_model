require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

require_relative 'xsd_model/types'

module XsdModel
  module Model
    module ClassMethods
      def build_with_xsd(path)
        file = File.open(path)
        xsd = Nokogiri::XML(file)
        # root_element_schema = Types::Schema.new(xsd.xpath('xs:schema/xs:element').first)
        root_element_schema = Types::Schema.new(xsd.xpath('xs:schema').first)

        class_variable_set(:@@schema, xsd)

        # include_active_model
        root_element_schema.define_attributes(self)

        schema
      end

      def schema
        class_variable_get(:@@schema)
      end

      def include_active_model
        include ActiveModel::Model
      end

      def const_missing(name)
        type_root = schema.xpath("xs:schema/xs:complexType[@name='#{name}']")

        klass = Class.new do
        end
        element_class = self.const_set(name, klass)

        root_element_schema = Types::Schema.new(type_root)
        root_element_schema.define_attributes(klass)

        klass
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
