# frozen_string_literal: true

RSpec.describe "Processing the sample CSV" do
  let(:email_format) { /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/ }

  let(:pipeline) do
    format = email_format

    CsvPipeline.define do
      field :name do
        transform :strip_whitespace
        default "empty"
        validate :presence
      end

      field :email do
        transform :strip_whitespace
        transform :downcase
        validate :presence
        validate format:
      end

      field :country do
        transform :strip_whitespace
        default "unknown"
      end
    end
  end

  subject(:report) do
    pipeline.process(File.expand_path("../examples/people.csv", __dir__))
  end

  it "produces the expected valid records" do
    expect(report.valid_records).to contain_exactly(
      { name: "Alice Smith", email: "alice@example.com", country: "germany" },
      { name: "empty", email: "bob@example.com", country: "france" },
      { name: "Dana", email: "dana@example.com", country: "italy" }
    )
  end

  it "reports the invalid rows with their reasons" do
    expect(report.errors.map(&:to_h)).to contain_exactly(
      { row: 3, field: :email, value: "not-an-email", message: "is invalid" },
      { row: 4, field: :email, value: "   ", message: "can't be blank" }
    )
  end
end
