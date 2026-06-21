# frozen_string_literal: true

RSpec.describe CsvPipeline::Rules::StripWhitespace do
  it "strips leading and trailing whitespace" do
    expect(described_class.new.call("  hi  ").value).to eq("hi")
  end

  it "passes through values that cannot be stripped" do
    result = described_class.new.call(nil)

    expect(result.value).to be_nil
    expect(result).not_to be_error
  end
end
