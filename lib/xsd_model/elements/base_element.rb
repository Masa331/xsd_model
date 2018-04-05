module XsdModel
  module Elements
    module BaseElement
      attr_accessor :children, :attributes, :namespaces

      def initialize(children = [], attributes = {}, namespaces = {})
        @children = children
        @attributes = attributes
        @namespaces = namespaces
      end

      def element_name
        self.class.name.demodulize.underscore
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

      def has_name?
        !name.nil?
      end

      def name
        attributes['name']
      end

      # def reverse_traverse(&block)
      #   children.each do |child|
      #     child.reverse_traverse(&block)
      #   end
      #
      #   yield self
      # end

      def reverse_traverse(&block)
        children_result = children.map do |child|
          child.reverse_traverse(&block)
        end

        yield self, children_result
      end
      # parsed.reverse_traverse { |element, a| puts "#{'-' * (1 + a.sum)}"; 1 + a.sum }
      # parsed.reverse_traverse { |element, a| puts "#{'-' * (1 + a.sum)} #{element.element_name} - #{element.attributes['name']}"; 1 + a.sum }
    end
  end
end
