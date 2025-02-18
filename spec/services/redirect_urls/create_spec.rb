require 'rails_helper'

RSpec.describe RedirectUrls::Create, type: :service do
  let(:original_url) { "https://example.com" }
  let(:expires_at) { nil }
  let(:custom_slug) { nil }
  subject { described_class.new(original_url: original_url, custom_slug: custom_slug, expires_at: expires_at) }
  let(:result) { subject.call }

  context "when saving succeeds" do
    context "without custom_slug" do
      it "creates a RedirectUrl with a slug" do
        redirect_url = subject.call

        expect(redirect_url).to be_persisted
        expect(redirect_url.original_url).to eq(original_url)
        expect(redirect_url.slug).to be_present
        expect(redirect_url.slug.length).to eq(7)
      end

      it "writes the created record to cache" do
        expect(Caches::Write).to receive(:call).and_call_original
        subject.call
      end
    end
  end

  context "with a valid custom_slug" do
    let(:custom_slug) { "custom1234" }
    it "creates a RedirectUrl with the provided custom_slug" do
      redirect_url = subject.call
      expect(redirect_url).to be_persisted
      expect(redirect_url.slug).to eq(custom_slug)
    end

    it "writes the created record to cache" do
      expect(Caches::Write).to receive(:call).and_call_original
      subject.call
    end
  end

  context "when expires_at is provided" do
    let(:expires_at) { 1.day.from_now }
    it "creates a RedirectUrl with the provided expires_at" do
      expected_time = expires_at
      redirect_url = subject.call

      expect(redirect_url.expires_at.to_i).to eq(expected_time.to_i)
    end
  end

  context "when the initial save fails" do
    context 'when the original_url is not a valid URL' do
      let(:original_url) { "http://" }
      let(:errors) do
        {
          original_url: [ "must be a valid https URL with a given host (for example, 'https://example.com')" ]
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

    context "when a custom_slug is provided with invalid length (exactly 7 characters)" do
      let(:custom_slug) { "abcdefg" }
      it "adds an error to :slug and does not persist the record" do
        result = subject.call

        expect(result).not_to be_persisted
        expect(result.errors[:slug]).to include("cannot be a 7-character slug because this length is only available for auto generated slugs ")
      end
    end
  end
end
