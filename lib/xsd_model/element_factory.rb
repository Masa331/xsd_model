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
      # can't use classify because there are classes like TotalDigits in plural
      # klass = XsdModel::Elements.const_get xml.name.classify
      klass = XsdModel::Elements.const_get xml.name.camelize
      element = klass.new
      element.attributes = xml.attributes.transform_values { |v| v.value }
      element.namespaces = xml.namespaces

      yield element if block_given?
      element
    end
  end
end
