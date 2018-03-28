require 'bundler/setup'
require 'xsd_model'

#TODO: How can i define this only on example group?
def Object.const_missing(name)
  if XsdModel::Elements.const_defined? name
    XsdModel::Elements.const_get name
  else
    super
  end
end

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
