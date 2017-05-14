require 'xsd_model/version'
require 'nokogiri'
require 'active_model'

module XsdModel
  module Types
    class XsString
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

    class XsInteger
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

    class XsDate
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

    class Text
      def initialize(schema)
      end

      def define_accessor(model)
      end
    end

    class ComplexType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.children

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].split(':').map(&:upcase_first).join

              "XsdModel::Types::#{t}".constantize
            else
              t = elem.name.upcase_first

              "XsdModel::Types::#{t}".constantize
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end

    class UserType
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        # require 'pry'; binding.pry
        t = @schema['type'].upcase_first
        method_name = @schema['name']

        # parents is rails method and -2 is class before Object
        element_class = model.ancestors.first.parents[-2].const_get(t)

        model.class_eval do
          define_method method_name do
            # @name ||= element_class.new
            instance_variable_get("@#{method_name}") || element_class.new
          end

          define_method method_name + "=" do |value|
            instance_variable_set("@#{method_name}", value)
            # @name = value
          end
        end
      end
    end

    class Sequence
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        elems = @schema.children

        elems.each do |elem|
          type_class =
            if elem['type'].present?
              if elem['type'].start_with?('xs:')
                t = elem['type'].split(':').map(&:upcase_first).join

                "XsdModel::Types::#{t}".constantize
              else
                # t = elem['type'].upcase_first

                # parents is rails method and -2 is class before Object
                # model.ancestors.first.parents[-2].const_get(t)

                XsdModel::Types::UserType
              end
            else
              t = elem.name.upcase_first

              "XsdModel::Types::#{t}".constantize
            end

          type_class.new(elem).define_accessor(model)
        end
      end
    end

    class Element
      def initialize(schema)
        @schema = schema
      end

      def define_accessor(model)
        method_name = @schema['name']

        klass = Class.new do
        end

        element_class = model.const_set(method_name + 'Type', klass)

        model.class_eval do
          define_method method_name do
            # @name ||= element_class.new
            instance_variable_get("@#{method_name}") || element_class.new
          end

          define_method method_name + "=" do |value|
            instance_variable_set("@#{method_name}", value)
            # @name = value
          end
        end

        elems = @schema.children
        elems.each do |elem|
          type_class =
            if elem['type'].present?
              t = elem['type'].split(':').map(&:upcase_first).join

              "XsdModel::Types::#{t}".constantize
            else
              t = elem.name.upcase_first

              "XsdModel::Types::#{t}".constantize
            end

          type_class.new(elem).define_accessor(element_class)
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
      elems = schema.children.presence || [schema]

      elems.each do |elem|
        type_class =
          if elem['type'].present?
            t = elem['type'].split(':').map(&:upcase_first).join

            "XsdModel::Types::#{t}".constantize
          else
            t = elem.name.upcase_first

            "XsdModel::Types::#{t}".constantize
          end

        type_class.new(elem).define_accessor(model)
      end
    end
  end

  module Model
    module ClassMethods
      def build_with_xsd(path)
        file = File.open(path)
        # class_variable_set(:@@schema, Schema.new(Nokogiri::XML(file)))
        xsd = Nokogiri::XML(file)
        root_element_schema = Schema.new(xsd.xpath('xs:schema/xs:element').first)

        class_variable_set(:@@schema, xsd)

        include_active_model
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

        root_element_schema = Schema.new(type_root)
        root_element_schema.define_attributes(klass)

        klass
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
