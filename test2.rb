require 'active_support/all'
load Dir.pwd + '/lib/xsd_model.rb'
# parsed.reverse_traverse { |element, a| puts "#{'-' * (1 + a.sum)} #{element.element_name} - #{element.attributes['name']}"; 1 + a.sum }

class ClassTemplate
  attr_accessor :name, :content

  def initialize(name, content)
    @name = name
    @content = content
  end
end

module Handlers
  def self.const_missing(sym)
    Blank
  end

  module Base
    attr_accessor :stack, :wip

    def push(value)
      self.stack.push(value)
    end

    def initialize(stack, wip = nil)
      @stack = stack
      @wip = wip
    end

    def method_missing(sym, *args)
      Handlers.const_get(sym.to_s.classify).new(stack, wip)
    end
  end

  class Sequence
    include Base

    def complex_type(source)
      if source.has_name?
        push ClassTemplate.new(source.name, wip)
        Blank.new(stack)
      else
        ComplexType.new stack, wip
      end
    end
  end

  class Element
    include Base

    def element(source)
      self.wip << source.name
      self
    end
  end

  class ComplexType
    include Base

    def element(source)
      push ClassTemplate.new(source.name, wip)
      Element.new(stack, [source.name])
    end
  end

  class Blank
    include Base

    def element(source)
      Element.new(stack, [source.name])
    end

    def document(_)
      @stack
    end
  end
end

schema = File.read('schema.xsd')
parsed = XsdModel.parse(schema, ignore: :text)

handler = Handlers::Blank.new([])

parsed.reverse_traverse do |element|
  handler = handler.send(element.element_name, element)
end

puts handler.map { |cl| "#{cl.name}: #{cl.content}" }
