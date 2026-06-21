# CsvPipeline

A small Ruby library for processing records from a CSV file through a configurable
pipeline of rules. Each rule either **transforms** a field (changes its value) or
**validates** it (checks a condition). The pipeline runs every rule and
**collects all errors** instead of stopping on the first one.

```ruby
pipeline = CsvPipeline.define do
  field :name do
    transform :strip_whitespace
    default "empty"
    validate :presence
  end

  field :email do
    transform :strip_whitespace
    transform :downcase
    validate :presence
    validate format: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
  end
end

report = pipeline.process("examples/people.csv")

report.valid_records # => [{ name: "Alice", email: "alice@example.com" }, ...]
report.errors        # => [#<Error row=3 field=:email value="nope" message="is invalid">, ...]
report.valid?        # => false
```

## Setup

Requires Ruby 3.1+ (developed on 3.4).

```bash
bundle install
bundle exec rspec        # run the test suite
bundle exec rubocop      # lint
bundle exec ruby examples/run.rb   # run the demo against the sample CSV
```

## Core concepts

The whole library is built on a single idea: **a rule is any object that responds
to `#call(value)` and returns a `Result`.**

```ruby
Result = (value, error)
```

- A **transformation** returns `Result.ok(new_value)`.
- A **validation** returns `Result.ok(value)` when it passes, or
  `Result.failure(value, message)` when it fails.

Because both kinds share one contract, the pipeline never needs to know which is
which. It just threads the value from one rule to the next and gathers any errors
along the way:

```ruby
final = rules.reduce(value) do |current, rule|
  result = rule.call(current)
  errors << result.error if result.error?
  result.value
end
```

That uniformity is the heart of the design — it is what makes rules compose
cleanly and what makes adding a new rule a one-method job.

### How the pieces fit together

| Component | Responsibility |
|-----------|----------------|
| `Result` | Immutable `(value, error)` returned by every rule |
| `Field` | An ordered list of rules for one column; threads value, collects errors |
| `Pipeline` | Reads the CSV, runs each field per row, produces a `Report` |
| `Report` | The outcome: `valid_records`, `invalid_rows`, `errors`, `valid?` |
| `Error` | A collected failure with `row`, `field`, `value`, `message` |
| `Registry` | Maps DSL names (`:presence`) to rule classes |
| `Builder` / `FieldBuilder` | The `define { field ... }` DSL, sugar over the registry |

## Built-in rules

| Name | Kind | Example |
|------|------|---------|
| `:strip_whitespace` | transform | `transform :strip_whitespace` |
| `:downcase` | transform | `transform :downcase` |
| `:default` | transform | `default "empty"` |
| `:presence` | validate | `validate :presence` |
| `:format` | validate | `validate format: /@/` |

The specific rules are intentionally minimal — the brief asks for an architecture
where new rules are easy to add, not for a large catalogue.

## Adding your own rule — without touching the library

There are two ways, depending on whether you want a reusable named rule or a
one-off.

**1. Any callable, inline.** Anything responding to `#call(value) -> Result`
works, including a lambda:

```ruby
titleize = ->(value) { CsvPipeline::Result.ok(value.to_s.capitalize) }

pipeline = CsvPipeline.define do
  field(:name) { apply titleize }
end
```

**2. A named rule, usable from the DSL like the built-ins.** Write a class with
a `#call` method and register it:

```ruby
class StartsWith
  def initialize(prefix)
    @prefix = prefix
  end

  def call(value)
    return CsvPipeline::Result.ok(value) if value.to_s.start_with?(@prefix)

    CsvPipeline::Result.failure(value, "must start with #{@prefix}")
  end
end

CsvPipeline.register(:starts_with, StartsWith)

pipeline = CsvPipeline.define do
  field :code do
    validate starts_with: "AB"
  end
end
```

Neither path requires editing any file inside `lib/` — that is the extensibility
goal made concrete (and both are covered in `spec/extensibility_spec.rb`).

## Design decisions

- **One rule protocol for transforms and validations.** Treating them as the same
  `#call(value) -> Result` contract is what keeps the pipeline tiny and makes
  composition and extension trivial. `transform` and `validate` in the DSL are
  intention-revealing aliases over the same mechanism.
- **Collect, never raise.** Processing a row never stops early. Every rule on
  every field runs, so a single pass surfaces *all* problems in the file — which
  is what you want when cleaning data.
- **Errors carry context.** Each `Error` records the row number, field, original
  input value, and message, so a failure is actionable without re-reading the CSV.
- **`format` skips blank values.** Presence owns the "is it there?" question;
  format only judges values that are present. This avoids two errors for one empty
  field and mirrors the familiar `allow_blank` convention.
- **Unmanaged columns pass through.** Columns without a `field` definition are
  preserved untouched in the output record.
- **Pluggable registry.** Named rules live in a registry. There is a shared
  default, and `Pipeline.define(registry:)` accepts an isolated one — handy for
  tests or for keeping app-specific rules out of global state.
- **Flexible input.** `process` accepts a file path or any IO-like object (e.g. a
  `StringIO`), which keeps the pipeline easy to unit-test.

## Testing

```bash
bundle exec rspec
```

The suite covers each rule in isolation, the value-threading and
error-collection in `Field`, the registry and DSL builder, full pipeline runs
(via `StringIO`), an end-to-end run against the sample CSV, and the two
extensibility paths. Edge cases include blank/nil/whitespace values, missing
columns, multiple errors per row, and not stopping on the first failure.

## Project layout

```
lib/csv_pipeline.rb            entry point, default registry, top-level API
lib/csv_pipeline/
  result.rb                    (value, error) returned by every rule
  field.rb                     threads a value through its rules
  pipeline.rb                  reads CSV, runs fields, builds the report
  report.rb  row_result.rb     results and accessors
  error.rb                     a collected failure
  registry.rb                  name -> rule class
  builder.rb  field_builder.rb the define { field ... } DSL
  source.rb                    reads a CSV path or IO into rows
  rules/                       the built-in rules, one file each
examples/people.csv            sample data: valid and invalid rows
examples/run.rb                runnable demo
spec/                          RSpec suite
```

## License

MIT
