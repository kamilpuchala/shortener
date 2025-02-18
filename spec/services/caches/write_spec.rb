# spec/caches/write_spec.rb
require 'rails_helper'

RSpec.describe Caches::Write do
  describe ".call" do
    let(:cache_key) { "cache:key" }
    let(:value) { "value" }
    let(:expires_in) { 2.minutes }

    it "writes value to the Rails cache" do
      described_class.call(cache_key: cache_key, value: value, expires_in: expires_in)
      expect(Caches::Fetch.call(cache_key: cache_key)).to eq(value)
    end
  end
end
