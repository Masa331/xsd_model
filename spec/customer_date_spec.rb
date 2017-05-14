require 'spec_helper'
require_relative 'test_classes/customer_date'

describe CustomerDate do
  it 'it has all accessors defined in xsd' do
    customer_date = CustomerDate.new

    expect(customer_date).to have_accessor :Customer_date
  end

  xcontext 'validations are performed through validators on model itself' do
    it 'is not valid with blank customer_date' do
      customer_date = CustomerDate.new

      customer_date.valid?

      expect(customer_date.errors['Customer_date']).to include "can't be blank"
    end

    it 'is valid with some date in customer_date' do
      customer_date = CustomerDate.new(Customer_date: Date.today)

      expect(customer_date).to be_valid
    end
  end

  xdescribe '#to_xml' do
    it "outputs model in xml valid by it's xsd" do
      customer_date = CustomerDate.new(Customer_date: Date.parse('26.10.2001'))

      expect(customer_date.to_xml.to_xml).to eq File.read('./spec/xml/customer_date.xml')
    end
  end

  xdescribe '::from_xml' do
    it 'intializes new instance from given xml' do
      xml = File.read('./spec/xml/customer_date.xml')
      customer_date = CustomerDate.from_xml(xml)

      expect(customer_date.Customer_date).to eq Date.parse('26.10.2001')
    end
  end
end
