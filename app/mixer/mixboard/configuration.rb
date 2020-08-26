# frozen_string_literal: true

module Mixboard
  # A mixer's configuration, usually set via an initializer
  class Configuration
    include Mixboard::UtilityFunctions

    attr_reader :channel_map

    def add_source(source_class)
      assert_non_nil_of_type(source_class, Class)
      sources.add(source_class)
      self
    end

    def add_sink(sink)
      assert_non_nil_of_type(sink, Mixboard::Sink)
      sinks.add(sink)
      self
    end

    def add_channel(channel)
      assert_non_nil_of_type(channel, Channel)
      channels.append(channel)
      self
    end

    def dynamic_channel_store=(dynamic_channel_store)
      assert_non_nil_of_type(dynamic_channel_store, Mixboard::DynamicChannelStore)
      @dynamic_channel_store = dynamic_channel_store
    end

    def dynamic_channel_store
      @dynamic_channel_store ||= Mixboard::InMemoryDynamicChannelStore.new
    end

    def setup_channel_map
      @channel_map = {}
      channels.each do |channel|
        @channel_map[channel.source_class] ||= []
        @channel_map[channel.source_class].append(channel)
      end
    end

    private

    def sources
      @sources ||= Set.new
    end

    def sinks
      @sinks ||= Set.new
    end

    # @return Array[Channel]
    def channels
      @channels ||= []
    end
  end
end
