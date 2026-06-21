# frozen_string_literal: true

module CsvPipeline
  module Rules
    class Downcase
      def call(value)
        return Result.ok(value) unless value.respond_to?(:downcase)

        Result.ok(value.downcase)
      end
    end
  end
end
