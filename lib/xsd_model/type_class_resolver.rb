module XsdModel
  class TypeClassResolver
    def self.call(element)
      new(element).call
    end

    attr_accessor :element

    def initialize(element)
      @element = element
    end

    def call
      if !element['type'].nil?
        t = element['type'].split(':').map(&:capitalize).join

        XsdModel::Types.const_get t
      else
        t = element.name
        t[0] = t[0].upcase

        XsdModel::Types.const_get t
      end

    end
  end
end
