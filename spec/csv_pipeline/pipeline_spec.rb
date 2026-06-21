# frozen_string_literal: true

require "stringio"

RSpec.describe CsvPipeline::Pipeline do
  let(:email_format) { /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ }

  let(:pipeline) do
    format = email_format

    CsvPipeline.define do
      field :name do
        default "empty"
        validate :presence
      end

      field :email do
        transform :strip_whitespace
        transform :downcase
        validate :presence
        validate format:
      end
    end
  end

  def process(csv)
    pipeline.process(StringIO.new(csv))
  end

  it "normalizes fields and reports valid records" do
    report = process("name,email\nAlice,  ALICE@Example.COM \n")

    expect(report).to be_valid
    expect(report.valid_records).to eq([{ name: "Alice", email: "alice@example.com" }])
  end

  it "applies a default to blank fields" do
    report = process("name,email\n,bob@example.com\n")

    expect(report.valid_records.first[:name]).to eq("empty")
  end

  it "collects errors across fields within a single row" do
    report = process("name,email\n,not-an-email\n")

    messages = report.errors.map { |error| [error.field, error.message] }
    expect(messages).to contain_exactly([:email, "is invalid"])
  end

  it "does not stop on the first failing row" do
    report = process("name,email\nA,bad\nB,worse\n")

    expect(report.errors.map(&:row)).to eq([1, 2])
  end

  it "annotates errors with row number, field and original value" do
    report = process("name,email\nCarlos,not-an-email\n")
    error = report.errors.first

    expect(error.row).to eq(1)
    expect(error.field).to eq(:email)
    expect(error.value).to eq("not-an-email")
  end

  it "treats a missing column as a blank value" do
    report = process("name\nAlice\n")

    expect(report.errors.map(&:field)).to eq([:email])
  end

  it "keeps unmanaged columns untouched" do
    report = process("name,email,note\nAlice,alice@example.com,keep me\n")

    expect(report.valid_records.first[:note]).to eq("keep me")
  end
end
