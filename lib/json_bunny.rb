require "multi_json"
require "bunny"
require "json_bunny/version"

module JsonBunny
  class Channel
    def initialize(raw_channel)
      @raw_channel = raw_channel
    end

    def queue(name, opts={})
      Queue.new(@raw_channel.queue(name, opts))
    end

    def fanout(name)
      Exchange.new(@raw_channel.fanout(name))
    end

    def topic(name)
      Exchange.new(@raw_channel.topic(name))
    end

    def direct(name)
      Exchange.new(@raw_channel.direct(name))
    end

    def default_exchange
      Exchange.new(@raw_channel.default_exchange)
    end
  end

  class Queue
    def initialize(raw_queue)
      @raw_queue = raw_queue
    end

    def bind(exchange, opts={})
      @raw_queue.bind(exchange.raw_exchange, opts)
    end

    def subscribe(opts={}, &block)
      @raw_queue.subscribe(opts) do |delivery_info, metadata, payload|
        event = MultiJson.load(payload)
        block.call(delivery_info, metadata, event)
      end
    end
  end

  class Exchange
    attr_reader :raw_exchange

    def initialize(exchange)
      @raw_exchange = exchange
    end

    def publish(message_hash, opts={})
      message_json = MultiJson.dump(message_hash)
      @raw_exchange.publish(message_json, opts.merge(content_type: 'application/json'))
    end
  end

  class Connection
    def initialize(connection_string)
      @connection = ::Bunny.new(connection_string)
    end

    def start
      @connection.start
    end

    def create_channel
      Channel.new(@connection.create_channel)
    end
  end
end
