require 'spec_helper'
require_relative 'test_classes/customer'

describe 'xs:group' do
  it 'works' do
    customer = Customer.new

    expect(customer).to have_accessor :Forename
    expect(customer).to have_accessor :Surname
    expect(customer).to have_accessor :Dob
  end
end
