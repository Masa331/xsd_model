require 'spec_helper'
require_relative 'test_classes/isdoc_invoice'

describe IsdocInvoice do
  it 'it has all accessors defined in xsd' do
    invoice = IsdocInvoice.new

    expect(invoice).to have_accessor :DocumentType
  end
end
