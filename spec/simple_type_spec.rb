require 'spec_helper'

class Version
  include XsdModel::Model

  build_with_xsd './spec/xsd/version.xsd'
end

describe 'SimpleType' do
  it 'works' do
    version = Version.new

    expect(version).to have_accessor :Number
  end
end
