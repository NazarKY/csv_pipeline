# frozen_string_literal: true

RSpec.describe CsvPipeline::Rules::Presence do
  it "fails on blank values" do
    result = described_class.new.call("")

    expect(result).to be_error
    expect(result.error).to eq("can't be blank")
  end

  it "passes on present values" do
    expect(described_class.new.call("here")).not_to be_error
  end

  it "supports a custom message" do
    expect(described_class.new("required").call(nil).error).to eq("required")
  end
end
