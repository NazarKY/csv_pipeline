# frozen_string_literal: true

module CsvPipeline
  class RowResult
    attr_reader :data, :errors

    def initialize(data:, errors:)
      @data = data
      @errors = errors
    end

    def valid?
      errors.empty?
    end
  end
end
