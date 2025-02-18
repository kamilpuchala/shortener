module Caches
  class Write
    def self.call(cache_key:, value:, expires_in:)
      Rails.cache.write(cache_key, value, expires_in: expires_in)
    end
  end
end
