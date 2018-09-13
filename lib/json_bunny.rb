require "multi_json"
require "bunny"
require "json_bunny/version"
require 'json_bunny/channel'

module JsonBunny
  class Connection
    def initialize(connection_string, connection_banner=nil)
      options = {
        :channel_max => 65535,
        :auth_mechanism => "PLAIN",

        properties: {
          :capabilities => {
            :publisher_confirms           => true,
            :consumer_cancel_notify       => true,
            :exchange_exchange_bindings   => true,
            :"basic.nack"                 => true,
            :"connection.blocked"         => true,
            # See http://www.rabbitmq.com/auth-notification.html
            :authentication_failure_close => true
          },
          :product      => connection_banner || "Bunny",
          :platform     => ::RUBY_DESCRIPTION,
          :version      => Bunny::VERSION,
          :information  => "http://rubybunny.info",
        }
      }
      @connection = ::Bunny.new(connection_string, options)
    end

    def start
      @connection.start
    end

    def close
      @connection.close
    end

    def create_channel
      Channel.new(@connection.create_channel)
    end
  end
end
