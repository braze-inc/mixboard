# frozen_string_literal: true

Mixboard::Mixer.instance.configure do |c|
  c.add_source(Mixboard::Sources::DummySource)
  c.add_sink(Mixboard::Sinks::DummySink.new)
end
