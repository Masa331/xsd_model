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
        type_root = schema.xpath("xs:schema/xs:complexType[@name='#{name}']")

        klass = Class.new do
          def define_accessor(model)
          end
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
