# frozen_string_literal: true

module CsvPipeline
  class Report
    def initialize(rows = [])
      @rows = rows
    end

    def add(row_result)
      @rows << row_result
      self
    end

    def valid_rows
      rows.select(&:valid?)
    end

    def invalid_rows
      rows.reject(&:valid?)
    end

    def valid_records
      valid_rows.map(&:data)
    end

    def errors
      rows.flat_map(&:errors)
    end

    def valid?
      errors.empty?
    end

    private

    attr_reader :rows
  end
end
