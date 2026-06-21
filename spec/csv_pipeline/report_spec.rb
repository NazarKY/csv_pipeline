# frozen_string_literal: true

RSpec.describe CsvPipeline::Report do
  def row(data, errors)
    CsvPipeline::RowResult.new(data:, errors:)
  end

  let(:error) { CsvPipeline::Error.new(row: 2, field: :email, value: "x", message: "is invalid") }

  subject(:report) do
    described_class.new
                   .add(row({ id: 1 }, []))
                   .add(row({ id: 2 }, [error]))
  end

  it "separates valid rows from invalid ones" do
    expect(report.valid_rows.map(&:data)).to eq([{ id: 1 }])
    expect(report.invalid_rows.map(&:data)).to eq([{ id: 2 }])
  end

  it "exposes the transformed data of valid rows" do
    expect(report.valid_records).to eq([{ id: 1 }])
  end

  it "flattens every collected error" do
    expect(report.errors).to eq([error])
  end

  it "is invalid when any row has errors" do
    expect(report).not_to be_valid
  end
end
