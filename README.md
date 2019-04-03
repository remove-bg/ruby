[![RemoveBG](resources/logo_black.png)](https://www.remove.bg/)

# Ruby library

[![CircleCI](https://circleci.com/gh/remove-bg/ruby/tree/master.svg?style=shield)](https://circleci.com/gh/remove-bg/ruby/tree/master) [![Gem Version](https://badge.fury.io/rb/remove_bg.svg)](https://rubygems.org/gems/remove_bg)

## Installation

- Add `gem "remove_bg"` to your application's Gemfile and then execute `bundle`.
- Or install it yourself as: `gem install remove_bg`

## Usage

### Configuring an API key

To configure a global API key (used by default unless overridden per request):

```ruby
RemoveBg.configure do |config|
  config.api_key = "<api-key>"
end
```

It's not recommended to commit your API key to version control. You may want to
read the API key from an environment variable (e.g.
`ENV.fetch("REMOVE_BG_API_KEY")`) or find an alternative method.

### Removing the background from an image

Currently the gem supports removing the background from a file or a URL:

```ruby
RemoveBg.from_file("image.png")
RemoveBg.from_url("http://example.com/image.png")
```

#### Request options

The processing options outlined in the [API reference](https://www.remove.bg/api)
can be specified per request:

```ruby
RemoveBg.from_file("image.png", size: "hd", type: "product", channels: "rgba")
```

The API key can also be specified per request:

```ruby
RemoveBg.from_file("image.png", api_key: "<api-key>")
```

#### Handling the result

Background removal requests return a result object which includes the processed
image data and the metadata about the operation.

```ruby
result = RemoveBg.from_file("image.png")
result.data             # => "\x89PNG..."
result.height           # => 333
result.width            # => 500
result.credits_charged  # => 1
```

There's also a `#save` convenience method:

```ruby
result.save("processed/image.png")
result.save("image.png", overwrite: true) # Careful!
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
