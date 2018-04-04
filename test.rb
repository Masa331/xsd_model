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
  module BaseHandler
    attr_accessor :source, :content

    def initialize(source = nil, content = [])
      @source = source
      @content = content
    end

    def << element
      send element.element_name, element, content
    end

    def method_missing(method_name, *args)
      klass = Handlers.const_get(method_name.to_s.classify)
      klass.new(args.first, args.last)
    end
  end

  class WIP
    include BaseHandler
  end

  class Element
    include BaseHandler

    def << element
      send element.element_name, element, content + [source.name]
    end
  end

  class ComplexType
    include BaseHandler

    def element element, content
      template = ClassTemplate.new(element.name, content)
      wip = WIP.new(nil, [element.name])
      throw(:element, [template, wip])
    end
  end

  class Sequence
    include BaseHandler

    def complex_type element, content
      if element.has_name?
        template = ClassTemplate.new(element.name, content)
        throw(:element, [template])
      else
        super
      end
    end
  end

  def self.const_missing(sym)
    WIP
  end
end

class Handler
  attr_reader :stack

  def initialize
    @wip = Handlers::WIP.new
    @stack = []
  end

  def << element
    catched = catch(:element) do |_|
      @wip = @wip << element
      nil
    end

    if catched
      @stack << catched[0]
      @wip = catched[1] || Handlers::WIP.new
    end
  end
end

schema = File.read('schema.xsd')
parsed = XsdModel.parse(schema, ignore: :text)

handler = Handler.new

parsed.reverse_traverse do |element|
  handler << element
end

puts handler.stack.map { |cl| "#{cl.name}: #{cl.content}" }
