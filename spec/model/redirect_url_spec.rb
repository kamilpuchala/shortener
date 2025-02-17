require "rails_helper"

RSpec.describe RedirectUrl, type: :model do
  describe "original_url validation" do
    context "with valid attributes" do
      subject { build(:redirect_url) }
      
      it { should validate_presence_of(:original_url) }
      it { should allow_value("https://example.com").for(:original_url) }
      it { should_not allow_value("invalid-url").for(:original_url) }
    end
  end
  
  describe "slug validation" do
    let(:redirect_url) { build(:redirect_url) }
    
    context "uniqueness of slug" do
      subject { create(:redirect_url) }
      
      it { should validate_uniqueness_of(:slug).allow_nil }
    end
    
    context "when slug is present" do
      it "is valid with a 7-character slug" do
        redirect_url.slug = "abcdefg"
        expect(redirect_url).to be_valid
      end
      
      it "is invalid with a slug shorter than 7 characters" do
        redirect_url.slug = "abc"
        expect(redirect_url).not_to be_valid
        expect(redirect_url.errors[:slug]).to include("is the wrong length (should be 7 characters)")
      end
      
      it "is invalid with a slug longer than 7 characters" do
        redirect_url.slug = "abcdefgh"
        expect(redirect_url).not_to be_valid
        expect(redirect_url.errors[:slug]).to include("is the wrong length (should be 7 characters)")
      end
    end
  end
end
