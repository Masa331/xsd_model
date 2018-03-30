# reload element factory
load Dir.pwd + '/lib/xsd_model/element_factory.rb'

# reload all elements
elements_dir = Dir.pwd + '/lib/xsd_model/elements'
element_paths = Dir.entries(elements_dir)
element_paths.delete '.'
element_paths.delete '..'
load elements_dir + '/base_element.rb'
element_paths.each do |p|
  load elements_dir + "/#{p}"
end

# scaffold missing elements
module XsdModel
  module Elements
    module BaseElement
      def self.const_missing(name)
        name = name.to_s
        puts "missing contant #{name}"

        template = File.read('./lib/xsd_model/elements/annotation.rb')
        template.gsub!('Annotation', name.to_s)

        File.open("./lib/xsd_model/elements/#{name.underscore}.rb", 'wb') { |f| f.write template }

        load Dir.pwd + "/lib/xsd_model/elements/#{name.underscore}.rb"

        const_get name
      end
    end
  end
end


# load Dir.pwd + '/lib/xsd_model.rb'; xml_str = File.read('./__Faktura.xsd'); model = XsdModel.parse(xml_str); collected = model.children.first.collect_included_schemas
