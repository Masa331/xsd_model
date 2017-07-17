require 'spec_helper'
require_relative 'test_classes/customer_date'

describe CustomerDate do
  it 'it has all accessors defined in xsd' do
    customer_date = CustomerDate.new

    expect(customer_date).to have_accessor :Customer_date
  end
end
