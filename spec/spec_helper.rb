$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'xsd_model'

RSpec::Matchers.define :have_accessor do |expected|
  match do |actual|
    test_value = 'something'

    actual.send "#{expected}=", test_value
    actual.send(expected) == test_value
  end
end
