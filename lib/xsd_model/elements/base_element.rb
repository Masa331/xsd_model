require 'xsd_model/elements/attribute_methods'
require 'xsd_model/xsdize'

module XsdModel
  module Elements
    module BaseElement
      extend AttributeMethods
      using Xsdize

      XSD_URI = 'http://www.w3.org/2001/XMLSchema'

      attr_accessor :children, :attributes, :namespaces, :css_path
      attribute_method :name, :type, :ref

      def initialize(*args, attributes: {}, namespaces: {}, css_path: '')
        @children = args.flatten
        @attributes = attributes
        @namespaces = namespaces
        @css_path = css_path
      end

      def xmlns_prefix
        nil if xmlns_uri.nil?

        ary = namespaces.to_a

        candidates = ary.select do |n|
          n[1] == xmlns_uri
        end.map(&:first)

        full_prefix = candidates.find do |c|
          c.start_with? 'xmlns:'
        end

        full_prefix&.gsub('xmlns:', '')
      end

      def xmlns_uri
        namespaces['xmlns']
      end

      def name_with_prefix
        [xmlns_prefix, name].compact.join(':')
      end

      def type_with_prefix
        if type&.include? ':'
          type
        else
          [xmlns_prefix, type].compact.join(':')
        end
      end

      def xsd_prefix
        namespaces.invert[XSD_URI].gsub('xmlns:', '')
      end

      def element_name
        self.class.name.demodulize.underscore
      end

      def has_custom_type?
        has_type? && !type.start_with?("#{xsd_prefix}:")
      end

      def basic_xsd_type?
        has_type? && type.start_with?("#{xsd_prefix}:")
      end

      def empty?
        children.empty?
      end

      def ==(other)
        (attributes == other.attributes) &&
          (children == other.children)
      end

      def reverse_traverse(&block)
        children_result = children.map do |child|
          child.reverse_traverse(&block)
        end

        yield self, children_result
      end

      #TODO: add similar #respond_to? method
      def method_missing(name, *args)
        super if name.to_s.end_with? '?'

        if XsdModel::Elements.const_defined? name.camelize # TotalDigits.. :]
          const = XsdModel::Elements.const_get name.camelize

          children.select { |child| child.is_a? const }
        elsif XsdModel::Elements.const_defined? name.camelize.singularize
          const = XsdModel::Elements.const_get name.camelize.singularize

          children.select { |child| child.is_a? const }
        else
          super
        end
      end
    end
  end
end
