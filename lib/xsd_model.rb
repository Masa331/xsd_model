require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

module XsdModel
  module Types
    class String
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        name = @schema['name']

        model.class_eval do
          attr_accessor name
        end
      end
    end

    class Date
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        name = @schema['name']

        model.class_eval do
          attr_accessor name
        end
      end
    end

    class ComplexType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.xpath('xs:complexType/xs:sequence/xs:element')

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].gsub('xs:', '').upcase_first

              "XsdModel::Types::#{t}".constantize
            else
              XsdModel::Types::ComplexType
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end
  end

  class Schema
    attr_accessor :schema

    def initialize(schema)
      @schema = schema
    end

    def define_attributes(model)
      elems = schema.xpath('xs:schema/xs:element')

      elems.each do |elem|
        type_class =
          if elem['type'].present?
            t = elem['type'].gsub('xs:', '').capitalize

            "XsdModel::Types::#{t}".constantize
          else
            XsdModel::Types::ComplexType
          end

        type_class.new(elem).define_accessor(model)
      end
    end
  end

  module Model
    module ClassMethods
      def build_with_xsd(path)
        file = File.open(path)
        class_variable_set(:@@schema, Schema.new(Nokogiri::XML(file)))

        include_active_model
        schema.define_attributes(self)

        schema
      end

      def schema
        class_variable_get(:@@schema)
      end

      def include_active_model
        include ActiveModel::Model
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
