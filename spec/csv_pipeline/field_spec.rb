# frozen_string_literal: true

RSpec.describe CsvPipeline::Field do
  it "threads the value through every rule in order" do
    field = described_class.new(:email, [
                                  CsvPipeline::Rules::StripWhitespace.new,
                                  CsvPipeline::Rules::Downcase.new
                                ])

    value, errors = field.process("  ME@Example.COM ")

    expect(value).to eq("me@example.com")
    expect(errors).to be_empty
  end

  it "collects every error instead of stopping on the first" do
    failing = ->(value) { CsvPipeline::Result.failure(value, "boom") }
    field = described_class.new(:code, [failing, failing])

    _value, errors = field.process("x")

    expect(errors).to eq(%w[boom boom])
  end

  it "keeps transforming even after a validation fails" do
    field = described_class.new(:email, [
                                  CsvPipeline::Rules::Presence.new,
                                  CsvPipeline::Rules::Downcase.new
                                ])

    value, errors = field.process("ABC")

    expect(value).to eq("abc")
    expect(errors).to be_empty
  end
end
