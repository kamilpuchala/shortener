FactoryBot.define do
  factory :redirect_url do
    original_url { "https://example.com" }
    slug { "abcdefg" }
  end
end
