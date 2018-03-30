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

      def traverse(&block)
        if block_given?
          children.each do |child|
            yield child

            child.traverse &block
          end
        else
          Enumerator.new do |enum|
            children.each do |child|
              enum.yield child

              child.traverse { |n| enum.yield n }
            end
          end
        end
      end
    end
  end
end
