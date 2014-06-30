require 'json_bunny/exchange'
require 'json_bunny/queue'

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

    def ack(delivery_tag, multiple=false)
      @raw_channel.ack(delivery_tag, multiple)
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
