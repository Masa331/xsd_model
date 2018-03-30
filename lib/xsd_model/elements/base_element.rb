module XsdModel
  module Elements
    module BaseElement
      attr_accessor :children, :attributes, :namespaces

      def initialize(children = [], attributes = {}, namespaces = {})
        @children = children
        @attributes = attributes
        @namespaces = namespaces
      end

      def structure
        { name: self.class.to_s.split('::').last,
          children: children.map { |ch| ch.structure } }
      end
    end
  end
end
