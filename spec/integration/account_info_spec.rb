# frozen_string_literal: true

require "remove_bg"

RSpec.describe "fetching account information" do
  let(:api_key) { ENV.fetch("REMOVE_BG_API_KEY") }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "succeeds with a valid API key" do
    account = VCR.use_cassette("account") do
      RemoveBg.account_info(api_key: api_key)
    end

    expect(account.api).to have_attributes(
      free_calls: be_a_kind_of(Numeric),
      sizes: "all"
    )

    expect(account.credits).to have_attributes(
      total: be_a_kind_of(Numeric),
      subscription: be_a_kind_of(Numeric),
      payg: be_a_kind_of(Numeric),
      enterprise: be_a_kind_of(Numeric),
    )
  end
end
