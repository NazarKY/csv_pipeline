# frozen_string_literal: true

module CsvPipeline
  module Rules
    class Format
      def initialize(pattern, message: "is invalid")
        @pattern = pattern
        @message = message
      end

      def call(value)
        return Result.ok(value) if Blank.blank?(value)
        return Result.ok(value) if value.to_s.match?(@pattern)

        Result.failure(value, @message)
      end
    end
  end
end
