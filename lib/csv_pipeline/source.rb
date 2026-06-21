# frozen_string_literal: true

require "csv"

module CsvPipeline
  module Source
    module_function

    def read(input)
      content = input.respond_to?(:read) ? input.read : File.read(input)
      CSV.parse(content, headers: true, header_converters: :symbol).map(&:to_h)
    end
  end
end
