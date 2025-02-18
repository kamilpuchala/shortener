FactoryBot.define do
  factory :redirect_url do
    original_url { "https://example.com" }
    slug { "abcdefg" }
    visits { 0 }
    expires_at { nil }
  end
end
