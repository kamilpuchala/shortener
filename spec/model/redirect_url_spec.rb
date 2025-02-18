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
      it "is valid with length <= 13" do
        redirect_url.slug = "a" * 13
        expect(redirect_url).to be_valid
      end

      it "is invalid with length > 13" do
        redirect_url.slug = "a" * 14
        expect(redirect_url).not_to be_valid
        expect(redirect_url.errors[:slug]).to include("is too long (maximum is 13 characters)")
      end
    end
  end

  describe "expires_at validation" do
    context "when expires_at is in the future" do
      let(:redirect_url) { build(:redirect_url, expires_at: 1.day.from_now) }

      it "is valid" do
        expect(redirect_url).to be_valid
      end
    end

    context "when expires_at is in the past" do
      let(:redirect_url) { build(:redirect_url, expires_at: 1.day.ago) }

      it "is invalid" do
        expect(redirect_url).not_to be_valid
        expect(redirect_url.errors[:expires_at]).to include("must be in the future")
      end
    end

    context "when expires_at is nil" do
      let(:redirect_url) { build(:redirect_url, expires_at: nil) }

      it "is valid" do
        expect(redirect_url).to be_valid
      end
    end
  end
end
