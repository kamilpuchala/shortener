require 'rails_helper'

RSpec.describe RedirectsRepository, :memory_cache do
  let(:repository) { described_class.new }
  let(:subject) { repository.find_redirect_parsed_url_with_cache(slug: redirect_url.slug) }
  let!(:redirect_url) { create(:redirect_url) }

  describe "#find_redirect_parsed_url_with_cache" do
    context "when the record exists" do
      let(:result_data) do
        RedirectUrl::CachedRedirectUrl.new(
          redirect_url.id,
          redirect_url.original_url,
          redirect_url.slug)
      end

      context "when record is not cached" do
        it "returns the correct result" do
            expect(subject).to eq(result_data)
          end

          it "doesn't return a data from cache" do
            expect(Caches::Fetch.call(cache_key: "redirect:#{redirect_url.slug}")).to eq(nil)
          end
        end

      context 'when record is cached' do
        it "returns the correct result" do
          subject

          expect(Caches::Fetch.call(cache_key: "redirect:#{redirect_url.slug}")).to eq(result_data)
        end

        it "uses the correct cache key" do
          cache_key = "redirect:#{redirect_url.slug}"
          expect(Rails.cache.exist?(cache_key)).to be_falsey

          repository.find_redirect_parsed_url_with_cache(slug: redirect_url.slug)
          expect(Rails.cache.exist?(cache_key)).to be_truthy
        end
      end

      context "when the record does not exist" do
        it "raises ActiveRecord::RecordNotFound" do
          expect {
            repository.find_redirect_parsed_url_with_cache(slug: "non-existent")
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
