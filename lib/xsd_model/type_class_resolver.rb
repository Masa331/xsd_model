module XsdModel
  class TypeClassResolver
    def self.call(element, model)
      new(element, model).call
    end

    attr_accessor :element, :model

    def initialize(element, model)
      @element = element
      @model = model
    end

    def call
      if !element['type'].nil? && element['type'].start_with?('xs:')
        t = element['type'].split(':').map(&:capitalize).join

        XsdModel::Types.const_get t
      elsif !element['type'].nil?
        XsdModel::Types::ElementWithUserType
      else
        t = element.name
        t[0] = t[0].upcase

        XsdModel::Types.const_get t
      end

    end
  end
end
