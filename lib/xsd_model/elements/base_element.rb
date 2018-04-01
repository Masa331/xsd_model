module XsdModel
  module Elements
    module BaseElement
      attr_accessor :children, :attributes, :namespaces

      def initialize(children = [], attributes = {}, namespaces = {})
        @children = children
        @attributes = attributes
        @namespaces = namespaces
      end

      # def array_structure
      #   { name: self.class.to_s.split('::').last,
      #     attributes: attributes.to_a.sort,
      #     children: children.map { |ch| ch.structure }.sort }.to_a
      # end
      # def <=>(other)
      #   structure <=> other.structure
      # end

      # def structure
      #   { name: self.class.to_s.split('::').last,
      #     children: children.map { |ch| ch.structure } }
      # end

      def ==(other)
        (attributes == other.attributes) &&
          (children == other.children)
      end

      def traverse(after_children_hook = Proc.new {}, &block)
        yield self

        children.each do |child|
          child.traverse(after_children_hook, &block)
        end

        after_children_hook.call(self)
      end
    end
  end
end
