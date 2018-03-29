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

      def includes
        children.select { |child| child.is_a? Elements::Include }
      end

      def collect_imported_schemas
        _collect_imported_schemas(self)
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

      def collect_included_schemas
        _collect_included_schemas(self)
      end

      def _collect_included_schemas(original_schema, collected_schemas = [], collected_paths = [])
        includes = original_schema.includes

        includes.each do |incl|
          unless collected_paths.include? incl.schema_location
            new_schema = incl.load
            collected_schemas << new_schema
            collected_paths << incl.schema_location

            _collect_included_schemas(new_schema, collected_schemas, collected_paths)
          end
        end

        collected_schemas
      end
    end
  end
end
