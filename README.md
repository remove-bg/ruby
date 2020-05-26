[![RemoveBG](resources/logo_black.png)](https://www.remove.bg/)

# Ruby library

[![CircleCI](https://circleci.com/gh/remove-bg/ruby/tree/master.svg?style=shield)](https://circleci.com/gh/remove-bg/ruby/tree/master) [![Gem Version](https://badge.fury.io/rb/remove_bg.svg)](https://rubygems.org/gems/remove_bg) [![codecov](https://codecov.io/gh/remove-bg/ruby/branch/master/graph/badge.svg)](https://codecov.io/gh/remove-bg/ruby)

## Quickstart installation

Add the gem to your `Gemfile` and run `bundle install`:

```
gem "remove_bg"
```

Or run `gem install remove_bg` to install globally.

Please note the base configuration has the following resolution limits:

| Output format | Resolution limit |
|---------------|------------------|
| PNG           | 10 megapixels    |
| JPG           | 25 megapixels    |

## Full installation

For best performance and quality the gem requires an image processing library.
Please install one of the following libraries:

- [ImageMagick](https://www.imagemagick.org/)
- [GraphicsMagick](http://www.graphicsmagick.org/)
- [libvips](http://libvips.github.io/libvips/)

The gem will auto-detect any image processing libraries present. However you may
prefer to explicitly configure which library to use:

```ruby
RemoveBg.configure do |config|
  config.image_processor = :minimagick # For ImageMagick or GraphicsMagick
  # or
  config.image_processor = :vips
end
```

The full installation has the following resolution limits:

| Output format | Resolution limit |
|---------------|------------------|
| PNG           | 25 megapixels    |
| JPG           | 25 megapixels    |
| ZIP           | 25 megapixels    |

# Usage

## Configuring an API key

To configure a global API key (used by default unless overridden per request):

```ruby
RemoveBg.configure do |config|
  config.api_key = "<api-key>"
end
```

It's not recommended to commit your API key to version control. You may want to
read the API key from an environment variable (e.g.
`ENV.fetch("REMOVE_BG_API_KEY")`) or find an alternative method.

## Removing the background from an image

Currently the gem supports removing the background from a file or a URL:

```ruby
RemoveBg.from_file("image.png")
RemoveBg.from_url("http://example.com/image.png")
```

## Request options

The processing options outlined in the [API reference](https://www.remove.bg/api)
can be specified per request:

```ruby
RemoveBg.from_file("image.png", size: "hd", type: "product", channels: "rgba")
```

The API key can also be specified per request:

```ruby
RemoveBg.from_file("image.png", api_key: "<api-key>")
```

## Handling the result

Background removal requests return a result object which includes the processed
image data and the metadata about the operation.

```ruby
result = RemoveBg.from_file("image.png")
result.data             # => "\x89PNG..."
result.height           # => 333
result.width            # => 500
result.credits_charged  # => 1.0
```

There's also a `#save` convenience method:

```ruby
result.save("processed/image.png")
result.save("image.png", overwrite: true) # Careful!
```

## Producing transparent images over 10 megapixels

After configuring a full installation (detailed above) you can process images
over 10 megapixels with a transparent output.

Process images with either the `png` or `zip` format. If you specify the `zip`
format it's possible to save the archive and handle composition yourself.

```ruby
result = RemoveBg.from_file("large-image.jpg", format: "zip")

result.save("result-with-transparency.png")
# or
result.save_zip("result.zip") # If you want to handle composition yourself
```

## Rate limits

The [API has rate limits][rate-limits]. Image processing results include the
rate limit information:

```ruby
result = RemoveBg.from_file("image.jpg")
result.rate_limit.to_s
# => <RateLimit reset_at='2020-05-20T12:00:00Z' total=500 remaining=499 retry_after_seconds=nil>
```

If you exceed the rate limit a `RemoveBg::RateLimitError` exception will be
raised. This also contains further information via the `#rate_limit` method.

[rate-limits]: https://www.remove.bg/api#rate-limit

## Fetching account information

To display the [account information][account-info] for the currently configured
API key:

[account-info]: https://www.remove.bg/api#operations-tag-Fetch_account_info

```ruby
account = RemoveBg.account_info # If an API key is set via RemoveBg.configuration
# or
account = RemoveBg.account_info(api_key: "<api_key>")

account.api.free_calls # => 50
account.credits.total  # => 200
```

## Examples

- [Bulk processing][bulk-processing] a directory of JPG and PNG files

[bulk-processing]: https://github.com/remove-bg/ruby/blob/master/examples/bulk_process.rb

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

Bug reports and pull requests are welcome on GitHub at [remove-bg/ruby](https://github.com/remove-bg/ruby).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).
