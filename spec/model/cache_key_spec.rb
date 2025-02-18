require 'rails_helper'

RSpec.describe CacheKey do
  it "has the correct redirect cache key" do
    expect(described_class::KEYS[:redirect][:value]).to eq("redirect")
    expect(described_class::KEYS[:redirect][:expires_in]).to eq(30.seconds)
  end

  it "has correct count of KEYS" do
    expect(described_class::KEYS.count).to eq(1)
  end
end
