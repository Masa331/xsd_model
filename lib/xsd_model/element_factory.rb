module XsdModel
  class ElementFactory
    def self.call(xml, &block)
      new(xml).call(&block)
    end

    attr_accessor :xml

    def initialize(xml)
      @xml = xml
    end

    def call
      klass = XsdModel::Elements.const_get xml.name.classify
      element = klass.new
      element.attributes = xml.attributes
      element.namespaces = xml.namespaces

      yield element if block_given?
      element
    end
  end
end
