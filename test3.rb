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
    attr_accessor :wip

    def initialize(wip = nil)
      @wip = wip
    end

    def method_missing(sym, *args)
      Handlers.const_get(sym.to_s.classify).new(wip)
    end
  end

  class Blank
    include Base

    def element(source)
      Handlers::Element.new(source.name)
    end

    def document(_)
      STACK
    end
  end

  class Sequence
    include Base

    def complex_type(source)
      if source.has_name?
        STACK.push ClassTemplate.new(source.name, wip)
        Blank.new
      else
        ComplexType.new wip
      end
    end
  end

  class ComplexType
    include Base

    def element(source)
      STACK.push ClassTemplate.new(source.name, wip)
      Handlers::Element.new(source.name)
    end
  end
end

class Stack
  include Singleton

  def initialize
    @stack = []
  end

  def push(value)
    @stack.push value
  end

  def to_a
    @stack
  end
end

class Array
  def handler
    if empty?
      Handlers::Blank.new
    elsif one?
      first
    else
      Handlers::Elements.new(flat_map(&:wip))
    end
  end
end

schema = File.read('schema.xsd')
parsed = XsdModel.parse(schema, ignore: :text)

STACK = Stack.instance

result = parsed.reverse_traverse do |element, childrens_result|
  childrens_result.handler.send(element.element_name, element)
end

puts result.to_a.map { |cl| "#{cl.name}: #{cl.content}" }
