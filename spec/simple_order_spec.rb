require 'spec_helper'
require_relative 'test_classes/simple_order'

describe SimpleOrder do
  it 'it has all accessors defined in xsd' do
    order = SimpleOrder.new

    expect(order).to have_accessor :Customer
    expect(order).to have_accessor :Supplier

    expect(order.Customer).to have_accessor :Dob
    expect(order.Customer).to have_accessor :Address

    expect(order.Supplier).to have_accessor :Phone
    expect(order.Supplier).to have_accessor :Address
  end
end
