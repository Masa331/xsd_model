require 'spec_helper'

RSpec.describe XsdModel::Elements::TotalDigits do
  describe '#element_name' do
    it "returns underscored XML element name" do
      element = TotalDigits.new

      expect(element.element_name).to eq 'total_digits'
    end
  end
end
