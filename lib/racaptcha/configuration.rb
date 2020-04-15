module RaCaptcha
  class Configuration
    # Store Captcha code where, this config more like Rails config.cache_store
    # [:null_store, :memory_store, :file_store]
    def cache_store
      @cache_store ||= [:file_store, "tmp/cache/racaptcha/session"]
    end

    def cache_store=(cache_store)
      @cache_store = cache_store
    end

    # racaptcha expire time, default 2 minutes
    def expires_in
      @expires_in ||= 2.minutes
    end

    def expires_in=(expires_in)
      @expires_in = expires_in
    end

    # Color style, default: :colorful, allows: [:colorful, :black_white]
    def style
      @style ||= :colorful
    end

    def style=(style)
      @style = style
    end

    # Chars length: default 5, allows: [3..7]
    def length
      @length ||= 5
    end

    def length=(length)
      @length = length
    end

    # strikethrough, default: true
    def strikethrough
      @strikethrough ||= true
    end

    def strikethrough=(strikethrough)
      @strikethrough = strikethrough
    end

    # outline style for hard mode, default: false
    def outline
      @outline ||= false
    end

    def outline=(outline)
      @outline = outline
    end
  end
end
