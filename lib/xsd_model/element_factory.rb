elements_dir = Dir.pwd + '/lib/xsd_model/elements'

element_paths = Dir.entries(elements_dir)
element_paths.delete '.'
element_paths.delete '..'

load elements_dir + '/base_element.rb'

element_paths.each do |p|
  load elements_dir + "/#{p}"
end

module XsdModel
  class ElementFactory
    def self.call(xml, options = {})
      new(xml, options).call
    end

    attr_accessor :xml

    def initialize(xml, options)
      @xml = xml
      @options = options
    end

    # def call
    #   name = xml.name
    #   children = xml.children.map { |child| ElementFactory.call(child) }
    #   attributes = xml.attributes
    #
    #   element_class = XsdModel::Elements.const_get name.classify
    #   element_class.new(children, attributes)
    # end

    def call
      name = xml.name
      klass = XsdModel::Elements.const_get name.classify
      klass.new
    end
  end
end
