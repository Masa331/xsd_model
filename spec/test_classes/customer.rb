class Customer
  include XsdModel::Model

  build_with_xsd './spec/xsd/customer.xsd'
end
