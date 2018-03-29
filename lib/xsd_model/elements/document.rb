module XsdModel
  module Elements
    class Document
      include BaseElement

      def schema
        children.find { |child| child.is_a? Elements::Schema }
      end
    end
  end
end
