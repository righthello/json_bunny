require 'json_bunny/rpc_timeout'

module JsonBunny
  class RpcClient
    def initialize(channel, routing_key, timeout=5)
      @channel = channel
      @routing_key = routing_key
      @timeout = timeout
    end

    def call(event)
      exchange = @channel.default_exchange
      queue = @channel.queue("", exclusive: true, auto_delete: true)

      correlation_id = SecureRandom.uuid

      exchange.publish(event, {
        routing_key: @routing_key,
        correlation_id: correlation_id,
        reply_to: queue.name
      })

      response = nil
      Timeout.timeout(@timeout) do
        queue.subscribe(block: true) do |delivery_info, properties, payload|
          if properties.correlation_id == correlation_id
            response = payload
            delivery_info.consumer.cancel
            channel.kill_work_pool
          end
        end
      end
      response
    rescue Timeout::Error
      raise RpcTimeout.new
    end
  end
end
