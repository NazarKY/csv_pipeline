# frozen_string_literal: true

module CsvPipeline
  module Rules
    class StripWhitespace
      def call(value)
        return Result.ok(value) unless value.respond_to?(:strip)

        Result.ok(value.strip)
      end
    end
  end
end
