# frozen_string_literal: true

module Mixboard
  # An in-memory store of dynamic channel assignments. You probably shouldn't use this because
  # it won't work right with multiple processes. Consider implementing a DynamicChannelStore with
  # a fast key-value store, like Redis or Memcached.
  class InMemoryDynamicChannelStore < Mixboard::DynamicChannelStore
    include Mixboard::UtilityFunctions

    def add_channel(id, channel, expiry = nil)
      assert_non_nil_of_type(channel, Mixboard::Channel)
      assert_type(expiry, Integer)
      channels_by_id[id] = [channel, expiry]
    end

    def remove_channel_by_id(id)
      channels_by_id.delete(id)
    end

    def channels
      channels_by_id.map do |id, tuple|
        [id, tuple[0], tuple[1]]
      end
    end

    private

    def channels_by_id
      @channels_by_id ||= {}
    end
  end
end
