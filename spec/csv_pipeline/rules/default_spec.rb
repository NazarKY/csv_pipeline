# frozen_string_literal: true

RSpec.describe CsvPipeline::Rules::Default do
  it "replaces blank values with the default" do
    rule = described_class.new("empty")

    expect(rule.call(nil).value).to eq("empty")
    expect(rule.call("   ").value).to eq("empty")
  end

  it "keeps present values untouched" do
    expect(described_class.new("empty").call("kept").value).to eq("kept")
  end

  it "never produces an error" do
    expect(described_class.new("empty").call(nil)).not_to be_error
  end
end
