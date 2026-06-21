# frozen_string_literal: true

module CsvPipeline
  class Registry
    class UnknownRule < KeyError; end

    def initialize
      @rules = {}
    end

    def register(name, rule_class)
      @rules[name.to_sym] = rule_class
      self
    end

    def build(name, *arguments)
      rule_class = @rules.fetch(name.to_sym) do
        raise UnknownRule, "unknown rule #{name.inspect}"
      end

      arguments.empty? ? rule_class.new : rule_class.new(*arguments)
    end
  end
end
