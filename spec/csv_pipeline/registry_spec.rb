# frozen_string_literal: true

RSpec.describe CsvPipeline::Registry do
  subject(:registry) { described_class.new }

  it "builds a registered rule without arguments" do
    registry.register(:presence, CsvPipeline::Rules::Presence)

    expect(registry.build(:presence)).to be_a(CsvPipeline::Rules::Presence)
  end

  it "builds a registered rule with arguments" do
    registry.register(:default, CsvPipeline::Rules::Default)

    expect(registry.build(:default, "x").call(nil).value).to eq("x")
  end

  it "raises a helpful error for unknown rules" do
    expect { registry.build(:nope) }
      .to raise_error(CsvPipeline::Registry::UnknownRule, /nope/)
  end
end
