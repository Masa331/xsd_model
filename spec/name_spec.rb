require 'spec_helper'
require_relative 'test_classes/name'

describe Name do
  it 'it has all accessors defined in xsd' do
    name = Name.new

    expect(name).to have_accessor :name
  end
end
