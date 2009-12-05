module Onlinenic
  class Connection
    require 'net/telnet'

    TCP_ESTABLISHED = 1
    TCP_CLOSE_WAIT  = 8
    TCP_INFO        = 11

    COMMANDS = {
            :check_contact  => "avail",
            :create_contact => "contactid",
            :update_contact => "contactid",
            :check_domain   => "avail",
            :info_domain    => nil
    }

    attr_reader :response

    def initialize
      connect
      login
    end

    #sets @conn(Net::Telnet) attribute
    def connect
      @config = Onlinenic::Config.get
      begin
        @conn = Net::Telnet::new(
                "Host"        => @config["server"],
                "Port"        => @config["port"],
                "Telnetmode"  => false
        )
        set_response
      rescue TimeoutError => e #TODO
        p e.message
      end
    end

    COMMANDS.each_pair do |method, result|
      define_method(method) do |params|
        begin
          check_connection
          @conn.write(Onlinenic::Request.send(method, @config, params))
          set_response
          result ? @response.get_data(result) : @response
        rescue TimeoutError => e #TODO
          p e.message
        end
      end
    end

    def login
      begin
        check_connection
        @conn.write(Onlinenic::Request.login(@config))
        set_response
      rescue TimeoutError => e #TODO
        p e.message
      end
    end

    def logout
      begin
        if established?
          @conn.write(Onlinenic::Request.logout(@config))
          set_response
        end
        close
        true
      rescue TimeoutError => e
        p e.message
      end
    end

    private

    #sets @response(Onlinenic::Response) attribute
    def set_response
      @response = Onlinenic::Response.new(@conn)
    end

    #if connection is not at ESTABLISHED state, re-initialize the connection
    def check_connection
      unless established?
        close if close_wait?
        initialize
      end
    end

    def close
      @conn.close
    rescue IOError => e
      p e.message
    end

    #is connection at ESTABLISHED state?
    def established?
      @conn.getsockopt(Socket::SOL_TCP, TCP_INFO).unpack("i").to_s.eql?(TCP_ESTABLISHED.to_s)
    rescue
      false
    end

    #is connection at CLOSE_WAIT state?
    def close_wait?
      @conn.getsockopt(Socket::SOL_TCP, TCP_INFO).unpack("i").to_s.eql?(TCP_CLOSE_WAIT.to_s)
    rescue
      false
    end

  end
end