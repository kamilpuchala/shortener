require 'rails_helper'

RSpec.describe Caches::Fetch do
  describe ".call" do
    let(:cache_key) { "cache:key" }
    let(:expires_in) { 1.minute }

    it "stores block result in cache and returns it" do
      result = described_class.call(cache_key: cache_key, expires_in: expires_in) { "cached_data" }
      expect(result).to eq("cached_data")

      expect(Rails.cache.read(cache_key)).to eq("cached_data")
    end

    it "does not overwrite existing cache if already present" do
      Rails.cache.write(cache_key, "already cached", expires_in: expires_in)

      result = described_class.call(cache_key: cache_key, expires_in: expires_in) { "cached_data" }
      expect(result).to eq("already cached")
    end
  end
end
