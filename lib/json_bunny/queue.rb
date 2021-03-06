require 'multi_json'

module JsonBunny
  class Queue
    def initialize(raw_queue)
      @raw_queue = raw_queue
    end

    def bind(exchange, opts={})
      if exchange.class.method_defined? :raw_exchange
        @raw_queue.bind(exchange.raw_exchange, opts)
      else
        @raw_queue.bind(exchange, opts)
      end

    end

    def subscribe(opts={}, &block)
      @raw_queue.subscribe(opts) do |delivery_info, metadata, payload|
        event = MultiJson.load(payload)
        block.call(delivery_info, metadata, event)
      end
    end

    def name
      @raw_queue.name
    end

    def message_count
      @raw_queue.message_count
    end

    def consumer_count
      @raw_queue.consumer_count
    end

    def purge
      @raw_queue.purge
    end
  end
end
