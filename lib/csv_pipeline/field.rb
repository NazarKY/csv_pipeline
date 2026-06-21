# frozen_string_literal: true

module CsvPipeline
  class Field
    attr_reader :name

    def initialize(name, rules)
      @name = name
      @rules = rules
    end

    def process(value)
      errors = []

      final = rules.reduce(value) do |current, rule|
        result = rule.call(current)
        errors << result.error if result.error?
        result.value
      end

      [final, errors]
    end

    private

    attr_reader :rules
  end
end
