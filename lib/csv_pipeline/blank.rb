# frozen_string_literal: true

module CsvPipeline
  module Blank
    module_function

    def blank?(value)
      return true if value.nil?
      return value.strip.empty? if value.respond_to?(:strip)
      return value.empty? if value.respond_to?(:empty?)

      false
    end
  end
end
