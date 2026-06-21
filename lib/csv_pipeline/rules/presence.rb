# frozen_string_literal: true

module CsvPipeline
  module Rules
    class Presence
      def initialize(message = "can't be blank")
        @message = message
      end

      def call(value)
        Blank.blank?(value) ? Result.failure(value, @message) : Result.ok(value)
      end
    end
  end
end
