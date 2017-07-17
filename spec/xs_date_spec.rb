require 'spec_helper'
require_relative 'test_classes/customer_date'

describe 'xs:date' do
  it 'works' do
    customer_date = CustomerDate.new

    expect(customer_date).to have_accessor :Customer_date
  end
end
