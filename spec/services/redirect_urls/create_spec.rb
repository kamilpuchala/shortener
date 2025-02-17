# spec/services/redirect_urls_create_spec.rb
require 'rails_helper'

RSpec.describe RedirectUrls::Create, type: :service do
  let(:original_url) { "https://example.com" }
  subject { described_class.new(original_url: original_url) }
  let(:result) { subject.call }
  
  context "when saving succeeds" do
    it "creates a RedirectUrl with a slug" do
      redirect_url = subject.call
      
      expect(redirect_url).to be_persisted
      expect(redirect_url.original_url).to eq(original_url)
      expect(redirect_url.slug).to be_present
      expect(redirect_url.slug.length).to eq(7)
    end
  end
  
  context "when the initial save fails" do
    context 'when the original_url is not a valid URL' do
      let(:original_url) { "http://" }
      let(:errors) do
        {
          original_url: ["must be a valid https URL with a given host (for example, 'https://example.com')"]
        }
      end
    
      it "returns errors" do
        expect(result.errors.messages).to eq(errors)
      end
    end
    
    context 'when the original_url is empty' do
      let(:original_url) { "" }
      let(:errors) do
        {
          original_url:
            [
              "can't be blank",
              "must be a valid https URL with a given host (for example, 'https://example.com')"
            ]
        }
      end
      
      it "returns errors" do
        expect(result.errors.messages).to eq(errors)
      end
    end
  end
  
  context "when updating the slug fails" do
    let(:errors) do
      {
        slug: ["is the wrong length (should be 7 characters)"]
      }
    end
    
    it "returns errors" do
      stub_const("RedirectUrls::GenerateSlug::OFFSET", 100)
      expect(result.errors.messages).to eq(errors)
    end
  end
end
