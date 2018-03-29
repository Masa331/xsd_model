module XsdModel
  module Elements
    class Schema
      include BaseElement

      def target_namespace
        attributes['targetNamespace'].value
      end

      def imports
        children.select { |child| child.is_a? Elements::Import }
      end

      def collect_imported_schemas
        _collect_imported_schemas(self, already_collected = [])
      end

      def _collect_imported_schemas(original_schema, already_collected = [])
        imports = original_schema.imports

        imports.each do |import|
          unless already_collected.map { |d| d.target_namespace }.include? import.namespace
            new_schema = import.load
            already_collected << new_schema
            _collect_imported_schemas(new_schema, already_collected)
          end
        end

        already_collected
      end
    end
  end
end
