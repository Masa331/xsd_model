class Note
  include XsdModel::Model

  build_with_xsd './spec/xsd/note.xsd'
end
