# frozen_string_literal: true

RSpec.describe RemoveBg do
  subject(:remove_bg) { Class.new { include RemoveBg } }

  describe "gem version" do
    it "can be retrieved" do
      expect(remove_bg.const_defined?(:VERSION)).to be true
    end

    it "is a string" do
      expect(remove_bg::VERSION).to be_a(String)
    end

    it "is a valid version string" do
      expect(remove_bg::VERSION).to match(/^\d+\.\d+\.\d+(\.\w+)?$/)
    end
  end
end
