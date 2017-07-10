class IsdocInvoice
  include XsdModel::Model

  build_with_xsd './spec/xsd/isdoc-invoice-6.0.1.xsd'
end
