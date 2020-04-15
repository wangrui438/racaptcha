# Racaptcha

This is a Captcha gem for ruby. It drawing captcha image with C code so it no dependencies.

If you want to use it in Rails, you can use [rucaptcha](https://github.com/huacnlee/rucaptcha) gem.

If you only want to use in the API, then this gem is exactly what you need.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'racaptcha'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install racaptcha

## Usage

Create `config/initializers/racaptcha.rb`

```rb
RaCaptcha.setup do |config|
  # Store Captcha code where, this config more like Rails config.cache_store
  # Default :file_store
  config.cache_store = [:file_store, 'tmp/cache/racaptcha/session']
  # racaptcha expire time, default 2 minutes
  config.expires_in = 2.minutes
  # Color style, default: :colorful, allows: [:colorful, :black_white]
  config.style = :colorful
  # Chars length: default 5, allows: [3..7]
  config.length = 5
  # enable/disable Strikethrough. default: true
  config.strikethrough = true
  # enable/disable Outline style, default: false
  config.outline = false
end
```

```rb
# generate captcha without cache
code, raw_data = RaCaptcha.generate

# generate captcha with cache
token, code, raw_data = RaCaptcha.generate_captcha

# verify captcha when using cache
RaCaptcha.verify_racaptcha?(cache_key: token, captcha: code)

# not delete cache when verify captcha
RaCaptcha.verify_racaptcha?(cache_key: token, captcha: code, keep_cache: true)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Racaptcha project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/racaptcha/blob/master/CODE_OF_CONDUCT.md).
