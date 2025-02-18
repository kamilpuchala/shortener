module RedirectUrls
  class GenerateSlug
    OFFSET = 56800235584 # 62^6 - ensure minimum length of 7 characters

    def initialize(id)
      @id = id
    end

    def call
      Base62Facade.encode(id + OFFSET)
    end

    private

    attr_reader :id
  end
end
