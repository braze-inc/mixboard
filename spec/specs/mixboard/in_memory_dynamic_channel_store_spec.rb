# frozen_string_literal: true

RSpec.describe Mixboard::InMemoryDynamicChannelStore do
  let(:dynamic_channel_store) { described_class.new }
  let(:channel) { build(:dummy_channel) }
  let(:channel_id) { :foo }
  let(:channel_expiry) { 300 }

  it 'supports adding channels' do
    dynamic_channel_store.add_channel(channel_id, channel, channel_expiry)
    expect(dynamic_channel_store.channels.count).to eq(1)
  end

  it 'supports overriding channels' do
    dynamic_channel_store.add_channel(channel_id, channel, channel_expiry)
    dynamic_channel_store.add_channel(channel_id, channel, channel_expiry)
    expect(dynamic_channel_store.channels.count).to eq(1)
  end

  it 'supports removing channels' do
    dynamic_channel_store.add_channel(channel_id, channel, channel_expiry)
    dynamic_channel_store.remove_channel_by_id(channel_id)
    expect(dynamic_channel_store.channels.count).to eq(0)
  end

  it 'supports removing channels by id that do not exist' do
    dynamic_channel_store.remove_channel_by_id(channel_id)
    expect(dynamic_channel_store.channels.count).to eq(0)
  end
end
