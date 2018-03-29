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

    # def self.const_missing(name)
    #   name = name.to_s
    #   puts "missing contant #{name}"
    #
    #   template = File.read('./lib/xsd_model/elements/schema.rb')
    #   template.gsub!('Schema', name.to_s)
    #
    #   File.open("./lib/xsd_model/elements/#{name.underscore}.rb", 'wb') { |f| f.write template }
    #
    #   load Dir.pwd + "/lib/xsd_model/elements/#{name.underscore}.rb"
    #
    #   const_get name
    # end
  end
end
