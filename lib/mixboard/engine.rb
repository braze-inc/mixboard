# frozen_string_literal: true

module Mixboard
  # The Rails engine for Mixboard
  class Engine < ::Rails::Engine
    isolate_namespace Mixboard

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end
