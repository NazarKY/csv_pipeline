# frozen_string_literal: true

RSpec.describe CsvPipeline::Result do
  describe ".ok" do
    it "carries the value and no error" do
      result = described_class.ok("value")

      expect(result.value).to eq("value")
      expect(result.error).to be_nil
      expect(result).not_to be_error
    end
  end

  describe ".failure" do
    it "carries both the value and the error" do
      result = described_class.failure("value", "is invalid")

      expect(result.value).to eq("value")
      expect(result.error).to eq("is invalid")
      expect(result).to be_error
    end
  end
end
