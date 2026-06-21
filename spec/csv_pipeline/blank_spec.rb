# frozen_string_literal: true

RSpec.describe CsvPipeline::Blank do
  describe ".blank?" do
    it "is true for nil, empty strings and whitespace" do
      expect(described_class.blank?(nil)).to be(true)
      expect(described_class.blank?("")).to be(true)
      expect(described_class.blank?("   ")).to be(true)
      expect(described_class.blank?([])).to be(true)
    end

    it "is false for present values" do
      expect(described_class.blank?("a")).to be(false)
      expect(described_class.blank?(0)).to be(false)
      expect(described_class.blank?(["a"])).to be(false)
    end
  end
end
