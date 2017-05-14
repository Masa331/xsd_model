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
  end

  xcontext 'validations are performed through validators on model itself' do
    it 'is valid in initial state' do
      order = Order.new

      expect(order).to be_valid
    end

    it 'is not valid with blank customer' do
      order = Order.new(Customer: nil)

      expect(order).not_to be_valid
    end

    it 'is not valid with blank supplier' do
      order = Order.new(Supplier: nil)

      expect(order).not_to be_valid
    end

    xit 'is not valid if customer has blank address' do
    end

    xit 'is not valid if supplier has blank address' do
    end
  end

  xdescribe '#to_xml' do
    it "outputs model in xml valid by it's xsd" do
      customer = Order::Customer.new(Dob: Date.parse('12.1.2000'),
                                     Address: Order::Address.new(Line1: '34 thingy street, someplace',
                                                                 Line2: 'sometown, w1w8uu '))
      supplier = Order::Supplier.new(Phone: '0123987654',
                                     Address: Order::Address.new(Line1: '22 whatever place, someplace',
                                                                 Line2: 'sometown, ss1 6gy '))

      order = Order.new(Customer: customer, Supplier: supplier)

      expect(order.to_xml.to_xml).to eq File.read('./spec/xml/order.xml')
    end
  end

  xdescribe '::from_xml' do
    it 'intializes new instance from given xml' do
      xml = File.read('./spec/xml/order.xml')
      order = Order.from_xml(xml)

      expect(order.Customer.Dob).to eq Date.parse('12.1.2000')
      expect(order.Customer.Address.Line1).to eq '34 thingy street, someplace'
      expect(order.Customer.Address.Line2).to eq 'sometown, w1w8uu '

      expect(order.Supplier.Phone).to eq '0123987654'
      expect(order.Supplier.Address.Line1).to eq '22 whatever place, someplace'
      expect(order.Supplier.Address.Line2).to eq 'sometown, ss1 6gy '
    end
  end
end
