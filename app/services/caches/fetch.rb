module Caches
  class Fetch
    def self.call(cache_key:, expires_in: 5.hours, &block)
      Rails.cache.fetch(cache_key, expires_in: expires_in) do
        block.call if block_given?
      end
    end
  end
end
