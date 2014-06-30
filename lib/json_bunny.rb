require "multi_json"
require "bunny"
require "json_bunny/version"
require 'json_bunny/channel'

module JsonBunny
  class Connection
    def initialize(connection_string)
      @connection = ::Bunny.new(connection_string)
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
