module RemoveBg
  module Api
    URL = "https://api.remove.bg"

    V1_REMOVE_BG = "/v1.0/removebg"
    private_constant :V1_REMOVE_BG

    HEADER_API_KEY = "X-Api-Key"
    private_constant :HEADER_API_KEY

    HEADER_TYPE = "X-Type"
    private_constant :HEADER_TYPE

    HEADER_WIDTH = "X-Width"
    private_constant :HEADER_WIDTH

    HEADER_HEIGHT = "X-Height"
    private_constant :HEADER_HEIGHT

    HEADER_CREDITS_CHARGED = "X-Credits-Charged"
    private_constant :HEADER_CREDITS_CHARGED
  end
end
