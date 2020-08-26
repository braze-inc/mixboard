# frozen_string_literal: true

module Mixboard
  # The Mixer is a singleton class that actually does the routing of signals.
  class Mixer
    include ::Singleton
    include Mixboard::UtilityFunctions

    CONFIGURATION_MUTEX = Mutex.new

    attr_writer :map_refresh_timeout

    # Accept a signal from a source to route it to the correct channels
    # @param [Signal] signal
    # @param [Source] source
    def accept(signal, source)
      assert_non_nil_of_type(signal, Signal)
      assert_non_nil_of_type(source, Source)
      (channel_map[source.class] || []).each do |channel|
        channel.accept(signal)
      end
    end

    def configure(&block)
      CONFIGURATION_MUTEX.synchronize do
        return unless @configuration.nil?

        c = Mixboard::Configuration.new
        block.call(c) if block_given?
        c.setup_channel_map
        @last_map_refresh = 0
        @configuration = c
      end
    end

    def clear_configuration
      @configuration = nil
    end

    def map_refresh_timeout
      @map_refresh_timeout ||= 30
    end

    def dynamic_channel_store
      configuration.dynamic_channel_store
    end

    private

    def channel_map
      refresh_channel_map if Time.now.to_i > last_map_refresh + map_refresh_timeout
      @channel_map
    end

    def refresh_channel_map
      @last_map_refresh = Time.now.to_i
      map = configuration.channel_map.dup

      configuration.dynamic_channel_store.active_channel_map.each do |source, channels|
        map[source] ||= []
        map[source].concat(channels)
      end

      @channel_map = map
    end

    def last_map_refresh
      @last_map_refresh ||= 0
    end

    def configuration
      raise 'Mixer not configured yet!' if @configuration.nil?

      @configuration
    end
  end
end
