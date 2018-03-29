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

    def call
      name = xml.name
      klass = XsdModel::Elements.const_get name.classify
      klass.new
    end
  end
end
