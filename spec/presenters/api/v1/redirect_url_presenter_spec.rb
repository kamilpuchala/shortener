require "rails_helper"

RSpec.describe Api::V1::RedirectUrlPresenter, type: :presenter do
  describe "#to_hash" do
    subject { described_class.new(redirect_url).to_hash }

    let(:redirect_url) { create(:redirect_url) }
    let(:expected_result) do
      {
        id: redirect_url.id,
        original_url: redirect_url.original_url,
        slug: redirect_url.slug,
        visits: redirect_url.visits,
        expires_at: redirect_url.expires_at
      }
    end

      it "returns hash with resources" do
        expect(subject).to eq(expected_result)
      end
  end
end
