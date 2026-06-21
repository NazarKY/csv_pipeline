# frozen_string_literal: true

module CsvPipeline
  class Builder
    attr_reader :fields

    def self.build(registry:, &)
      builder = new(registry)
      builder.instance_eval(&)
      Pipeline.new(builder.fields)
    end

    def initialize(registry)
      @registry = registry
      @fields = []
    end

    def field(name, &)
      field_builder = FieldBuilder.new(@registry)
      field_builder.instance_eval(&)
      @fields << Field.new(name, field_builder.rules)
    end
  end
end
