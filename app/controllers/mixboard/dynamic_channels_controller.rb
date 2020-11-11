require_dependency "mixboard/application_controller"

module Mixboard
  class DynamicChannelsController < ApplicationController
    def index
      @dynamic_channel_store = Mixboard::Mixer.instance.dynamic_channel_store
      @dynamic_channels = @dynamic_channel_store.channels
    end

    def start_create_wizard


    end

    def create

      params[:step]
    end

    def destroy
    end
  end
end
