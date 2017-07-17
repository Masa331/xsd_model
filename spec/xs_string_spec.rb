require 'spec_helper'
require_relative 'test_classes/name'

describe 'xs:string' do
  it 'works' do
    name = Name.new

    expect(name).to have_accessor :name
  end
end
