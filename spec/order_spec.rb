require 'spec_helper'
require_relative 'test_classes/order'

describe Order do
  it 'it has all accessors defined in xsd' do
    order = Order.new

    expect(order).to have_accessor :Customer
    expect(order).to have_accessor :Supplier

    expect(order.Customer).to have_accessor :Dob
    expect(order.Customer).to have_accessor :Address

    expect(order.Supplier).to have_accessor :Phone
    expect(order.Supplier).to have_accessor :Address

    expect(order.Customer.Address).to have_accessor :Line1
    expect(order.Customer.Address).to have_accessor :Line2

    expect(order.Supplier.Address).to have_accessor :Line1
    expect(order.Supplier.Address).to have_accessor :Line2
  end
end
