require 'xsd_model/xsdize'

module XsdModel
  module Elements
    module AttributeMethods
      using Xsdize

      def attribute_method(*attr_names)
        attr_names.each do |attr_name|
          define_method attr_name.underscore do
            attributes[attr_name.to_s]
          end

          define_method "has_#{attr_name.underscore}?" do
            !attributes[attr_name.to_s].nil?
          end

          define_method "no_#{attr_name.underscore}?" do
            attributes[attr_name.to_s].nil?
          end
        end
      end
    end
  end
end
