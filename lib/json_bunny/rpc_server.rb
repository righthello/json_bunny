module JsonBunny
  class RpcServer
    def initialize(channel, queue_name, options={})
      @channel = channel
      @queue_name = queue_name
      @options = options
    end

    def on_request(&block)
      queue = @channel.queue(@queue_name, @options)
      exchange = @channel.default_exchange

      queue.subscribe do |delivery_info, properties, event|
        result_hash = block.call(event)
        exchange.publish(result_hash, routing_key: properties.reply_to, correlation_id: properties.correlation_id)
      end
    end
  end
end
