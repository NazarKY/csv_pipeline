# frozen_string_literal: true

module CsvPipeline
  class Result
    attr_reader :value, :error

    def self.ok(value)
      new(value:)
    end

    def self.failure(value, error)
      new(value:, error:)
    end

    private_class_method :new

    def initialize(value:, error: nil)
      @value = value
      @error = error
    end

    def error?
      !error.nil?
    end
  end
end
