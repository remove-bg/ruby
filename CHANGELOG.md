# Changelog

## 2.1.1



---


#### 🚨 Security

- 🚨 [security] Update json 2.10.1 → 2.10.2 (patch) [#57](https://github.com/remove-bg/ruby/pull/57)

#### 🔀 Dependencies

- Update all Bundler dependencies (2025-03-12) [#56](https://github.com/remove-bg/ruby/pull/56)


## 2.1.0

## What's Changed
* Update Ruby 3.3.6 → 3.3.7 by @depfu in https://github.com/remove-bg/ruby/pull/51
* Update all Bundler dependencies (2025-01-29) by @depfu in https://github.com/remove-bg/ruby/pull/52
* Update all Bundler dependencies (2025-02-12) by @depfu in https://github.com/remove-bg/ruby/pull/53
* Update all Bundler dependencies (2025-03-05) by @depfu in https://github.com/remove-bg/ruby/pull/55


**Full Changelog**: https://github.com/remove-bg/ruby/compare/2.0.6...2.1.0

---


#### 🔀 Dependencies

- Update all Bundler dependencies (2025-03-05) [#55](https://github.com/remove-bg/ruby/pull/55)
- Update all Bundler dependencies (2025-02-12) [#53](https://github.com/remove-bg/ruby/pull/53)
- Update all Bundler dependencies (2025-01-29) [#52](https://github.com/remove-bg/ruby/pull/52)
- Update Ruby 3.3.6 → 3.3.7 [#51](https://github.com/remove-bg/ruby/pull/51)


## 2.0.6

#### 🔀 Dependencies

- Update all Bundler dependencies (2025-01-15) [#50](https://github.com/remove-bg/ruby/pull/50)


## 2.0.5



---


#### 🔀 Dependencies

- Update all Bundler dependencies (2025-01-01) [#49](https://github.com/remove-bg/ruby/pull/49)
- Update all Bundler dependencies (2024-12-19) [#48](https://github.com/remove-bg/ruby/pull/48)
- Update all Bundler dependencies (2024-12-04) [#47](https://github.com/remove-bg/ruby/pull/47)


## 2.0.4



---


#### 🚨 Security

- 🚨 [security] Update rexml 3.3.7 → 3.3.9 (patch) [#43](https://github.com/remove-bg/ruby/pull/43)

#### 🔀 Dependencies

- Update all Bundler dependencies (2024-11-20) [#46](https://github.com/remove-bg/ruby/pull/46)
- Update all Bundler dependencies (2024-11-13) [#45](https://github.com/remove-bg/ruby/pull/45)
- Update Ruby 3.3.5 → 3.3.6 [#44](https://github.com/remove-bg/ruby/pull/44)
- Update all Bundler dependencies (2024-09-11) [#42](https://github.com/remove-bg/ruby/pull/42)


## 2.0.3

## What's Changed
* Update all Bundler dependencies (2024-08-28) by @depfu in https://github.com/remove-bg/ruby/pull/41


**Full Changelog**: https://github.com/remove-bg/ruby/compare/2.0.2...2.0.3

## 2.0.2



---


#### 🚨 Security

- 🚨 [security] Update rexml 3.3.2 → 3.3.4 (patch) [#39](https://github.com/remove-bg/ruby/pull/39)

#### 🔀 Dependencies

- Update all Bundler dependencies (2024-08-22) [#40](https://github.com/remove-bg/ruby/pull/40)
- Update all Bundler dependencies (2024-07-31) [#38](https://github.com/remove-bg/ruby/pull/38)


## 2.0.1

#### 🚀 Enhancements:

- Remove deprecated File [#37](https://github.com/remove-bg/ruby/pull/37)
- Update Ruby to 3.3.4 [#36](https://github.com/remove-bg/ruby/pull/36)

#### 🐞 Bugfixes:

- Fix redefined constant warning [#35](https://github.com/remove-bg/ruby/pull/35)

#### 🔀 Dependencies

- Update all Bundler dependencies (2024-07-17) [#34](https://github.com/remove-bg/ruby/pull/34)


## 2.0.0

- Deprecate `overwrite: true` in favour of `save!` and `save_zip!`
- Remove support for Ruby 2.5, 2.6, 2.7 and 3.0 [which are EOL](https://www.ruby-lang.org/en/downloads/branches/)
- Deprecate Faraday < 2, add support for all Faraday 2.x versions
- Increase default timeout to 20 seconds

---


#### 🚀 Enhancements:

- Add support for Faraday 2.x [#31](https://github.com/remove-bg/ruby/pull/31)

#### 🚨 Security

- 🚨 [security] Update rexml 3.2.6 → 3.2.8 (patch) [#27](https://github.com/remove-bg/ruby/pull/27)


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
