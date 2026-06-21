# frozen_string_literal: true

RSpec.describe CsvPipeline::Rules::Format do
  subject(:rule) { described_class.new(/\A\d+\z/) }

  it "passes when the value matches the pattern" do
    expect(rule.call("123")).not_to be_error
  end

  it "fails when the value does not match" do
    result = rule.call("12a")

    expect(result).to be_error
    expect(result.error).to eq("is invalid")
  end

  it "skips blank values so presence owns that error" do
    expect(rule.call("")).not_to be_error
    expect(rule.call(nil)).not_to be_error
  end

  it "supports a custom message" do
    rule = described_class.new(/\A\d+\z/, message: "must be numeric")

    expect(rule.call("x").error).to eq("must be numeric")
  end
end
