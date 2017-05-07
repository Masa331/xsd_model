require 'spec_helper'
require_relative 'test_classes/note'

xdescribe Note do
  xit 'it has all accessors defined in xsd' do
    note = Note.new

    expect(note).to have_accessor :to
    expect(note).to have_accessor :from
    expect(note).to have_accessor :heading
    expect(note).to have_accessor :body
  end
end
