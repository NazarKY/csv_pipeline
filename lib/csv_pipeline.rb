# frozen_string_literal: true

require_relative "csv_pipeline/version"
require_relative "csv_pipeline/blank"
require_relative "csv_pipeline/result"
require_relative "csv_pipeline/error"
require_relative "csv_pipeline/registry"
require_relative "csv_pipeline/rules/strip_whitespace"
require_relative "csv_pipeline/rules/downcase"
require_relative "csv_pipeline/rules/default"
require_relative "csv_pipeline/rules/presence"
require_relative "csv_pipeline/rules/format"
require_relative "csv_pipeline/field"
require_relative "csv_pipeline/row_result"
require_relative "csv_pipeline/report"
require_relative "csv_pipeline/source"
require_relative "csv_pipeline/field_builder"
require_relative "csv_pipeline/builder"
require_relative "csv_pipeline/pipeline"

module CsvPipeline
  class << self
    def registry
      @registry ||= default_registry
    end

    def register(name, rule_class)
      registry.register(name, rule_class)
    end

    def define(registry: self.registry, &block)
      Pipeline.define(registry:, &block)
    end

    private

    def default_registry
      Registry.new
              .register(:strip_whitespace, Rules::StripWhitespace)
              .register(:downcase, Rules::Downcase)
              .register(:default, Rules::Default)
              .register(:presence, Rules::Presence)
              .register(:format, Rules::Format)
    end
  end
end
