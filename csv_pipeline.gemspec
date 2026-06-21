# frozen_string_literal: true

require_relative "lib/csv_pipeline/version"

Gem::Specification.new do |spec|
  spec.name = "csv_pipeline"
  spec.version = CsvPipeline::VERSION
  spec.authors = ["Nazar Kovalchuk"]
  spec.email = ["kovalchukny@gmail.com"]

  spec.summary = "Process CSV records through a configurable pipeline of transformation and validation rules."
  spec.description = "CsvPipeline reads records from a CSV source and runs each field through an ordered " \
                     "pipeline of composable rules, collecting every error instead of stopping on the first one."
  spec.homepage = "https://github.com/rekoval/csv_pipeline"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.glob("lib/**/*.rb") + %w[README.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "csv", "~> 3.3"
end
