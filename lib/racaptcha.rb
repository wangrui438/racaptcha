require "active_support/all"
require "racaptcha/version"
require "racaptcha/racaptcha"
require "racaptcha/configuration"
require "racaptcha/errors/configuration"

module RaCaptcha
  class << self
    def setup
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def cache
      @cache ||= ActiveSupport::Cache.lookup_store(config.cache_store)
    end

    # generate new captcha without cache
    def generate
      style = config.style == :colorful ? 1 : 0
      length = config.length
      unless length.in?(3..7)
        raise RaCaptcha::Errors::Configuration, 'length config error, value must in 3..7'
      end
      strikethrough = config.strikethrough ? 1 : 0
      outline = config.outline ? 1 : 0
      self.create(style, length, strikethrough, outline)
    end

    # generate new captcha with cache
    def generate_captcha(cache_key = nil)
      res = generate
      _key = generate_cache_key(cache_key)
      _val = { code: res[0], time: Time.now.to_i }
      cache.write(_key, _val, expires_in: config.expires_in)
      [_key, res[0], res[1]]
    end

    # verify captcha
    #
    # exmaple:
    #
    #   verify_racaptcha?(cache_key: 'xxx', captcha: 'xxx')
    #   verify_racaptcha?(cache_key: 'xxx', captcha: 'xxx', keep_cache: true)
    #
    def verify_racaptcha?(options = {})
      options ||= {}

      _key = generate_cache_key(options[:cache_key])
      store_info = cache.read(_key)
      # Make sure move used key
      cache.delete(_key) unless options[:keep_cache]

      # Make sure session exist
      return false if store_info.blank?

      # Make sure not expire
      return false if (Time.now.to_i - store_info[:time]) > config.expires_in

      # Make sure have captcha
      captcha = (options[:captcha] || '').downcase.strip
      return false if captcha.blank?

      return false if captcha != store_info[:code]

      true
    end

    private

    def generate_cache_key(cache_key = nil)
      cache_key ||= ['racaptcha-token', Digest::SHA256.hexdigest(SecureRandom.uuid)].join(":")
    end
  end
end
