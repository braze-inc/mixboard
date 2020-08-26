# frozen_string_literal: true

FactoryBot.define do
  factory :dummy_source, class: 'Mixboard::Sources::DummySource'
  factory :dummy_sink, class: 'Mixboard::Sinks::DummySink'
  factory :dummy_filter, class: 'Mixboard::Filters::DummyFilter'
  factory :dummy_signal_processor, class: 'Mixboard::SignalProcessors::DummySignalProcessor'
  factory :dummy_channel, class: 'Mixboard::Channel' do
    after :build do |channel|
      channel.add_source('Mixboard::Sources::DummySource'.constantize).add_sink(build(:dummy_sink))
    end
  end
end
