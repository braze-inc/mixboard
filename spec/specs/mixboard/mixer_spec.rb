# frozen_string_literal: true

RSpec.describe Mixboard::Mixer do
  let(:mixer) { described_class.instance }
  let(:source) { build(:dummy_source) }
  let(:sink) { build(:dummy_sink) }
  let(:channel) { Mixboard::Channel.new.add_source(source.class).add_sink(sink) }

  after do
    mixer.clear_configuration
  end

  shared_examples 'simple source and sink' do
    it 'routes the source signal to the sink' do
      expect(sink).to receive(:accept)
      source.log
    end
  end

  context 'with a static channel' do
    before do
      mixer.configure do |c|
        c.add_channel(channel)
      end
    end

    it_behaves_like 'simple source and sink'
  end

  context 'with a dynamic channel' do
    context 'when it is not expired' do
      before do
        mixer.configure
        mixer.dynamic_channel_store.add_channel(:dummy, channel, Time.now.to_i + 300)
      end

      it_behaves_like 'simple source and sink'
    end

    context 'when it has no expiry' do
      before do
        mixer.configure
        mixer.dynamic_channel_store.add_channel(:dummy, channel, nil)
      end

      it_behaves_like 'simple source and sink'
    end

    context 'when it is expired' do
      before do
        mixer.configure
        mixer.dynamic_channel_store.add_channel(:dummy, channel, 0)
      end

      it 'routes the source signal to the sink' do
        expect(sink).not_to receive(:accept)
        source.log
      end
    end
  end
end
