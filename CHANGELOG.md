# Changelog

## 2.0.0
 - Upgrade Faraday version to support faraday v2
 - Deprecate `overwrite: true` in favour of `save!` and `save_zip!`

## 1.5.0

- Auto-detect any available image processing libraries
- Reduce bandwidth usage by using ZIP format where possible

## 1.4.1

- Fixes binary encoding issue - via [#15](https://github.com/remove-bg/ruby/pull/15)

## 1.4.0

- Adds support for images up to 25 megapixels ([documentation](https://github.com/remove-bg/ruby#processing-images-over-10-megapixels))
  - Requires an image processing library to be configured (ImageMagick, GraphicsMagick or libvips)

## 1.3.0

- Add `RemoveBg.account_info` which includes available credits - via [#9](https://github.com/remove-bg/ruby/pull/9)
- Fix support for Faraday `1.0` - via [#7](https://github.com/remove-bg/ruby/pull/7)
- Raise minimum Faraday version to `0.15.0`

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
