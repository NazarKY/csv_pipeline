# frozen_string_literal: true

RSpec.describe CsvPipeline::Rules::Downcase do
  it "downcases the value" do
    expect(described_class.new.call("HeLLo").value).to eq("hello")
  end

  it "passes through values that cannot be downcased" do
    expect(described_class.new.call(nil).value).to be_nil
  end
end
