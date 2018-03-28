module XsdModel
  module Elements
    class Document
      include BaseElement

      def schema
        schemas.first
      end
    end
  end
end
