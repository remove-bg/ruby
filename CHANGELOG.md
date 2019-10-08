# Changelog

## 1.2.1

- Add `type` attribute to result object (`X-Type` header from API) - via [#2](https://github.com/remove-bg/ruby/pull/2)

## 1.2.0

- Support uppercase file extensions (e.g. `.JPG`)
- Add Faraday 1.0 support (currently RC1)

## 1.1.0

- Support 'credits charged' as a float (API change)

## 1.0.0

Initial release supporting background removal from files or URLs:

- `RemoveBg.from_file("image.png")`
- `RemoveBg.from_url("http://example.com/image.png")`
