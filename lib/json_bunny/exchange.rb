require 'multi_json'

module JsonBunny
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
end
