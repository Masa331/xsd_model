class SimpleOrder
  include XsdModel::Model

  build_with_xsd './spec/xsd/simple_order.xsd'
end
