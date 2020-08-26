# frozen_string_literal: true

RSpec.describe Mixboard::Channel do
  let(:source) { build(:dummy_source) }
  let(:filter) { build(:dummy_filter) }
  let(:sink) { build(:dummy_sink) }
  let(:channel) { described_class.new.add_source(source.class).add_sink(sink) }

  shared_examples 'simple source and sink' do
    it 'routes the source signal to the sink' do
      expect(sink).to receive(:accept)
      channel.accept(source.signal_class.new)
    end
  end

  it_behaves_like 'simple source and sink'

  shared_examples 'single filter' do
    it 'calls the filter' do
      expect(filter).to receive(:filter)
      channel.accept(source.signal_class.new)
    end
  end

  context 'when the channel has a before filter' do
    before do
      channel.add_before_filter(filter)
    end

    it_behaves_like 'simple source and sink'
    it_behaves_like 'single filter'
  end

  context 'when the channel has an after filter' do
    before do
      channel.add_after_filter(filter)
    end

    it_behaves_like 'simple source and sink'
    it_behaves_like 'single filter'
  end

  context 'when the channel has a signal processor' do
    let(:signal_processor) { build(:dummy_signal_processor) }

    before do
      channel.add_signal_processor(signal_processor)
    end

    it_behaves_like 'simple source and sink'

    it 'transforms the signal' do
      expect(signal_processor).to receive(:transform)
      channel.accept(source.signal_class.new)
    end
  end
end
