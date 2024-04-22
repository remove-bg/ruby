# frozen_string_literal: true

require "remove_bg/url_validator"

RSpec.describe RemoveBg::UrlValidator do
  it "permits valid, absolute URLs" do
    expect { validate("http://example.com/image.png") }.to_not raise_error
  end

  it "rejects nil URLs" do
    expect { validate(nil) }.to raise_invalid_url_error
  end

  it "rejects empty URLs" do
    expect { validate("") }.to raise_invalid_url_error
  end

  it "rejects URLs with unrecognised schemes" do
    expect { validate("htp:://example.com/") }.to raise_invalid_url_error
  end

  it "rejects relative URLs" do
    expect { validate("image.png") }.to raise_invalid_url_error
  end

  private

  def validate(url)
    described_class.validate(url)
  end

  def raise_invalid_url_error
    raise_error(RemoveBg::InvalidUrlError) do |ex|
      expect(ex.message).to match(/Invalid URL/)
      expect(ex).to respond_to(:url)
    end
  end
end
