# frozen_string_literal: true

module RemoveBg
  module Api
    URL = "https://api.remove.bg"

    V1_ACCOUNT = "/v1.0/account"
    private_constant :V1_ACCOUNT

    V1_REMOVE_BG = "/v1.0/removebg"
    private_constant :V1_REMOVE_BG

    HEADER_API_KEY = "X-Api-Key"
    private_constant :HEADER_API_KEY
  end
end
