# frozen_string_literal: true

RSpec.describe Mixboard::SignalProcessor do
  let(:source) { build(:dummy_source) }
  let(:filter) { build(:dummy_filter) }
  let(:signal_processor) { build(:dummy_signal_processor) }

  shared_examples 'transforms the signal' do
    it 'routes the signal through the signal processor' do
      expect(signal_processor).to receive(:transform)
      signal_processor.do_transform(source.signal_class.new)
    end
  end

  it_behaves_like 'transforms the signal'

  shared_examples 'single filter' do
    it 'calls the filter' do
      expect(filter).to receive(:filter)
      signal_processor.do_transform(source.signal_class.new)
    end
  end

  context 'when the signal processor has a before filter' do
    before do
      signal_processor.add_before_filter(filter)
    end

    it_behaves_like 'transforms the signal'
    it_behaves_like 'single filter'
  end

  context 'when the signal processor has an after filter' do
    before do
      signal_processor.add_after_filter(filter)
    end

    it_behaves_like 'transforms the signal'
    it_behaves_like 'single filter'
  end
end
