$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'xsd_model'

RSpec::Matchers.define :have_accessor do |expected|
  match do |actual|
    initial_value = actual.send(expected)
    test_value = 'something'

    actual.send "#{expected}=", test_value
    result = actual.send(expected) == test_value

    # i need to set back initial value or subsequent accessor tests won't work
    actual.send "#{expected}=", initial_value

    result
  end
end
