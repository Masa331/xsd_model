class CustomerDate
  include XsdModel::Model

  build_with_xsd './spec/xsd/customer_date.xsd'
end
