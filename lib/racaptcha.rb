require "active_support/all"
require "racaptcha/racaptcha"
require "racaptcha/version"
require "racaptcha/configuration"
require "racaptcha/errors/configuration"

module RaCaptcha
  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config.style         = :colorful
      @config.length        = 5
      @config.strikethrough = true
      @config.outline       = false
      @config.expires_in    = 2.minutes
      @config.skip_cache_store_check = false

      @config.cache_store = :file_store
      @config.cache_store
      @config
    end

    def setup(&block)
      config.instance_exec(&block)
    end

    def cache
      return @cache if defined? @cache

      @cache = ActiveSupport::Cache.lookup_store(RaCaptcha.config.cache_store)
      @cache
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
      create(style, length, strikethrough, outline)
    end

    # generate new captcha with cache
    def generate_captcha(cache_key = nil)
      res = RaCaptcha.generate
      _val = {
        code: res[0],
        time: Time.now.to_i
      }
      RaCaptcha.cache.write(generate_cache_key(cache_key), _val, expires_in: RaCaptcha.config.expires_in)
      res[1]
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
      store_info = RaCaptcha.cache.read(_key)
      # Make sure move used key
      RaCaptcha.cache.delete(_key) unless options[:keep_cache]

      # Make sure session exist
      return false if store_info.blank?

      # Make sure not expire
      return false if (Time.now.to_i - store_info[:time]) > RaCaptcha.config.expires_in

      # Make sure have captcha
      captcha = (options[:captcha] || "").downcase.strip
      return false if captcha.blank?

      return false if captcha != store_info[:code]

      true
    end

    private

    def generate_cache_key(session_id = nil)
      session_id_digest = Digest::SHA256.hexdigest(session_id.to_s)
      ["racaptcha-token", session_id_digest].join(":")
    end
  end
end
