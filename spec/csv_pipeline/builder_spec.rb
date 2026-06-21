# frozen_string_literal: true

require "stringio"

RSpec.describe CsvPipeline::Builder do
  it "applies the transforms and validations declared in the DSL" do
    pipeline = described_class.build(registry: CsvPipeline.registry) do
      field :email do
        transform :strip_whitespace
        validate format: /@/
      end
    end

    report = pipeline.process(StringIO.new("email\n  a@b \nno-at-sign\n"))

    expect(report.valid_records).to eq([{ email: "a@b" }])
    expect(report.errors.map(&:message)).to eq(["is invalid"])
  end

  it "accepts any callable through apply" do
    pipeline = described_class.build(registry: CsvPipeline.registry) do
      field(:name) { apply ->(value) { CsvPipeline::Result.ok(value.to_s.upcase) } }
    end

    report = pipeline.process(StringIO.new("name\nalice\n"))

    expect(report.valid_records).to eq([{ name: "ALICE" }])
  end
end
