# Mixboard

Mixboard is a framework for routing signals from sources to sinks. Signals can be metrics,
log messages, errors, or any other similar piece of information one might want to route
from a source to a sink. Conditional routing is available via filters, and transformation
of signals is possible via signal processors. A specific end-to-end route is called a channel.

It's a common pattern to spend a non-trivial amount of time enabling and disabling
logs, metrics, or other types of debugging information on a per-customer or a
per-business-object basis. Instead, this framework provides the tooling to do this type of
observability work ahead of time (i.e. inserting the proper signalling) and be able to
enable/disable it selectively at runtime or via configuration.

## Usage

Mixboard is designed as a Rails Engine, so usage is straightforward. A simple example
is below.

### Signals

A signal is a payload containing information that can be routed through the mixer.

First, create a signal by extending `Mixboard::Signal` if you aren't using a generic
signal type, like so:

```ruby
class DummySignal < Mixboard::Signal
  attr_accessor :my_attribute
end
```

#### Signal Levels

Signals have levels associated with them, similar to log messages. Using levels,
it's easy to subcategorize or delineate the granularity of signals. The provided
levels are: `verbose`, `debug`, `info`, `warn`, and `error`, similar to most
logging frameworks. These are often helpful when using filters.

### Sources

A source is anything that emits signals of a certain type.

Create a source by extending `Mixboard::Source`, making sure the methods you
plan on using on your source are calling the `emit` method with a signal instance,
like so:

```ruby
class DummySource < Mixboard::Source
  def signal_class
    DummySignal
  end

  def my_logging_method
    signal = DummySignal.new
    signal.my_attribute = 'FizzBuzz'
    emit(signal)
  end
end
```

### Sinks

A sink is anything that accepts signals of a certain type.

Create a sink by extending `Mixboard::Sink` if you aren't using a generic sink, 
making sure to provide an `accept` method, like so:

```ruby
class DummySink < Mixboard::Sink
  def signal_class
    DummySignal
  end

  def accept(signal)
    MyExternalLoggingService.post(signal.my_attribute) 
  end
end
```

### Configuration

To statically configure channels, create a `mixboard.rb` initializer and
configure a channel, like so:
```ruby
Mixboard::Mixer.configure do |c|
  channel = Mixboard::Channel.new
    .add_source(DummySource)
    .add_sink(DummySink.new(any_config_options))

  c.add_channel(channel)
end
```

And you should be all set. You can instantiate your `DummySource` anywhere, use
`my_logging_method`, and Mixboard will connect the two components!

To dynamically configure channels... TODO!

### Signal Processors

Signal processors accept signals of a certain type and emit signals of a certain type.
The are used for transforming signals from one type to another.

Imagine wanting to send an error message to something like Sentry, but also wanting to 
track it as a metric in StatsD. You would set up two channels:

- Source: Logger; Sink: SentrySink
- Source: Logger; Sink: StatsDCountMetricSink

For the first channel, the signal types match (assuming they are both something simple,
such as `MessageSignal`, so you don't need to associate a signal processor. For the 
second channel, you have a source type of `MessageSignal`, and a sink type of `CountMetric`.
You would need to add a signal processor that accepts `MessageSignal` (or a superclass),
and emits `CountMetric`. Your channels would look like:

- Source: Logger; Sink: SentrySink
- Source: Logger; Sink: StatsDCountMetricSink, SignalProcessors: MessageSignalCounter

Your signal processor might look like:

```ruby
class MessageSignalCounter < Mixboard::SignalProcessor
  def initialize(metric_name:)
    @metric_name = metric_name
  end

  def input_signal_class
    MessageSignal
  end

  def output_signal_class
    CountMetric
  end

  def transform(signal)
    return CountMetric.new(@metric_name, 1)
  end
end
```

### Filters

Filters interrupt the flow of signals through the system. You can add filters before or
after channels and signal processors. Here's a simple example:

```ruby
class DummyFilter < Mixboard::Filter
  def signal_class
    DummySignal
  end

  def filter(signal)
    signal
  end
end
```

Filters' `filter` method should only return the original signal to continue processing, or
return nil to indicate to stop processing the signal further.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'mixboard'
```

Or install it yourself as:
```bash
$ gem install mixboard
```

To take advantage of the dynamic "mixing panel" to configure channels... TODO

## Contributing
Contribution directions go here. TODO

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
