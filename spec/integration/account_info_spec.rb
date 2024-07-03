# frozen_string_literal: true

RSpec.describe "fetching account information" do
  let(:api_key) { "test-api-key" }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "succeeds with a valid API key" do
    account = VCR.use_cassette("account") do
      RemoveBg.account_info(api_key:)
    end

    expect(account.api).to have_attributes(
      free_calls: be_a(Numeric),
      sizes: "all"
    )

    expect(account.credits).to have_attributes(
      total: be_a(Numeric),
      subscription: be_a(Numeric),
      payg: be_a(Numeric),
      enterprise: be_a(Numeric),
    )
  end
end
