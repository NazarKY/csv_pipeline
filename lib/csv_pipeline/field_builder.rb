# frozen_string_literal: true

module CsvPipeline
  class FieldBuilder
    attr_reader :rules

    def initialize(registry)
      @registry = registry
      @rules = []
    end

    def transform(rule)
      @rules << resolve(rule)
    end

    def validate(rule)
      @rules << resolve(rule)
    end

    def default(value)
      @rules << @registry.build(:default, value)
    end

    def apply(callable)
      @rules << callable
    end

    private

    def resolve(rule)
      case rule
      when Symbol
        @registry.build(rule)
      when Hash
        name, argument = rule.first
        @registry.build(name, argument)
      else
        rule
      end
    end
  end
end
