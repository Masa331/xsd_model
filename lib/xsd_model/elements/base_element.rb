module XsdModel
  module Elements
    module BaseElement
      attr_accessor :children, :attributes

      def initialize(children = [], attributes = {})
        @children = children
        @attributes = attributes
      end

      def structure
        { name: self.class.to_s.split('::').last,
          children: children.map { |ch| ch.structure } }
      end
    end
  end
end
