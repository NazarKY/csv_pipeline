# frozen_string_literal: true

module CsvPipeline
  module Rules
    class Default
      def initialize(default_value)
        @default_value = default_value
      end

      def call(value)
        Blank.blank?(value) ? Result.ok(@default_value) : Result.ok(value)
      end
    end
  end
end
