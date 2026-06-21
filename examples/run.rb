# frozen_string_literal: true

require_relative "../lib/csv_pipeline"

EMAIL_FORMAT = /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/

class Upcase
  def call(value)
    return CsvPipeline::Result.ok(value) unless value.respond_to?(:upcase)

    CsvPipeline::Result.ok(value.upcase)
  end
end

CsvPipeline.register(:upcase, Upcase)

pipeline = CsvPipeline.define do
  field :name do
    transform :strip_whitespace
    default "empty"
    validate :presence
  end

  field :email do
    transform :strip_whitespace
    transform :downcase
    validate :presence
    validate format: EMAIL_FORMAT
  end

  field :country do
    transform :strip_whitespace
    default "unknown"
    transform :upcase
  end
end

report = pipeline.process(File.join(__dir__, "people.csv"))

puts "Valid records (#{report.valid_records.size}):"
report.valid_records.each { |record| puts "  #{record}" }

puts
puts "Errors (#{report.errors.size}):"
report.errors.each { |error| puts "  #{error}" }
