require 'spec_helper'
require_relative 'test_classes/simple_order'

describe '2 level deep of complex types' do
  it 'works' do
    order = SimpleOrder.new

    expect(order).to have_accessor :Customer
    expect(order).to have_accessor :Supplier

    expect(order.Customer).to have_accessor :Dob
    expect(order.Customer).to have_accessor :Address

    expect(order.Supplier).to have_accessor :Phone
    expect(order.Supplier).to have_accessor :Address
  end
end
