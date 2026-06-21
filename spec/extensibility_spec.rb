# frozen_string_literal: true

require "stringio"

RSpec.describe "Adding custom rules without modifying the library" do
  it "accepts an inline callable through apply" do
    titleize = ->(value) { CsvPipeline::Result.ok(value.to_s.capitalize) }

    pipeline = CsvPipeline.define do
      field(:name) { apply titleize }
    end

    report = pipeline.process(StringIO.new("name\nalice\n"))

    expect(report.valid_records).to eq([{ name: "Alice" }])
  end

  it "accepts a registered named rule usable from the DSL" do
    stub_const("StartsWith", Class.new do
      def initialize(prefix)
        @prefix = prefix
      end

      def call(value)
        return CsvPipeline::Result.ok(value) if value.to_s.start_with?(@prefix)

        CsvPipeline::Result.failure(value, "must start with #{@prefix}")
      end
    end)

    registry = CsvPipeline::Registry.new.register(:starts_with, StartsWith)

    pipeline = CsvPipeline::Pipeline.define(registry:) do
      field :code do
        validate starts_with: "AB"
      end
    end

    report = pipeline.process(StringIO.new("code\nXY1\n"))

    expect(report.errors.first.message).to eq("must start with AB")
  end
end
