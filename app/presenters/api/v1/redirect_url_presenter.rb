  module Api
    module V1
      class RedirectUrlPresenter < SimpleDelegator
        attr_reader :redirect_url

        def to_hash
          {
            id: id,
            original_url: original_url,
            slug: slug,
            visits: visits,
            expires_at: expires_at
          }
        end
      end
    end
  end
