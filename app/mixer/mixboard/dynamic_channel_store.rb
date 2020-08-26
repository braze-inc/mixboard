# frozen_string_literal: true

module Mixboard
  # A DynamicChannelStore is an interface for a dynamically populated set of channels. The canonical implementation
  # is InMemoryDynamicChannelStore, but you could implement this with another backing store, such as Redis or Memcached.
  class DynamicChannelStore
    include Mixboard::UtilityFunctions

    def add_channel(_id, _channel, _expiry = nil)
      declare_abstract_method_body
    end

    def remove_channel_by_id(_id)
      declare_abstract_method_body
    end

    def channels
      declare_abstract_method_body
    end

    def active_channel_map
      map = {}
      channels.each do |id, channel, expiry|
        if !expiry.nil? && Time.now.to_i > expiry
          remove_channel_by_id(id)
          next
        end
        map[channel.source_class] ||= []
        map[channel.source_class].append(channel)
      end
      map
    end
  end
end
