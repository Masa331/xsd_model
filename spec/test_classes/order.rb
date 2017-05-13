class Order
  include XsdModel::Model

  build_with_xsd './spec/xsd/order.xsd'
end
