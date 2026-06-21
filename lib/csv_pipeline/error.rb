# frozen_string_literal: true

module CsvPipeline
  class Error
    attr_reader :row, :field, :value, :message

    def initialize(row:, field:, value:, message:)
      @row = row
      @field = field
      @value = value
      @message = message
    end

    def to_s
      "row #{row}, #{field}: #{message}"
    end

    def to_h
      { row:, field:, value:, message: }
    end
  end
end
