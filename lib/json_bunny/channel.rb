require 'json_bunny/exchange'
require 'json_bunny/queue'
require 'json_bunny/rpc_client'
require 'json_bunny/rpc_server'

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

    def topic(name, opts={})
      Exchange.new(@raw_channel.topic(name, opts))
    end

    def direct(name)
      Exchange.new(@raw_channel.direct(name))
    end

    def default_exchange
      Exchange.new(@raw_channel.default_exchange)
    end

    def rpc_client(routing_key, timeout=5)
      RpcClient.new(self, routing_key, timeout)
    end

    def rpc_server(queue_name)
      RpcServer.new(self, queue_name)
    end

    def ack(delivery_tag, multiple=false)
      @raw_channel.ack(delivery_tag, multiple)
    end

    def exchange_declare(name, type, opts = {})
      @raw_channel.exchange_declare(name, type, opts)
    end

    def register_exchange(exchange)
      @raw_channel.register_exchange(exchange)
    end

    def nack(delivery_tag, multiple=false, requeue=false)
      @raw_channel.reject(delivery_tag, multiple, requeue)
    end

    def reject(delivery_tag, requeue=false)
      @raw_channel.reject(delivery_tag, requeue)
    end

    def prefetch(count)
      @raw_channel.prefetch(count)
    end

    def kill_work_pool
      @raw_channel.work_pool.kill
    end
  end
end
