require 'rails_helper'

RSpec.describe RedirectUrls::GenerateSlug do
  describe "#call" do
    let(:id) { 100 }
    subject { described_class.new(id).call }
    
    it "calls Base62Facade.encode with (id + OFFSET)" do
      expected_arg = id + described_class::OFFSET
      expect(Base62Facade).to receive(:encode).with(expected_arg).and_return("slug123")
      expect(subject).to eq("slug123")
    end
  end
end
