# frozen_string_literal: true

module CsvPipeline
  class Pipeline
    def self.define(registry: CsvPipeline.registry, &block)
      Builder.build(registry:, &block)
    end

    def initialize(fields)
      @fields = fields
    end

    def process(input)
      Source.read(input).each_with_index.reduce(Report.new) do |report, (row, index)|
        report.add(process_row(row, index + 1))
      end
    end

    private

    attr_reader :fields

    def process_row(row, number)
      data = row.dup
      errors = []

      fields.each do |field|
        value, field_errors = field.process(row[field.name])
        data[field.name] = value
        field_errors.each do |message|
          errors << Error.new(row: number, field: field.name, value: row[field.name], message:)
        end
      end

      RowResult.new(data:, errors:)
    end
  end
end
