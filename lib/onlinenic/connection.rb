module Onlinenic
  class Connection
    require 'net/telnet'

    def initialize
      connect
      login
    end

    def response
      @response
    end

    #sets @conn(Net::Telnet) attribute
    def connect
      @config = Onlinenic::Config.get
      begin
        @conn = Net::Telnet::new(
                "Host"        => @config["server"],
                "Port"        => @config["port"],
                "Telnetmode"  => false,
                "Timeout"     => 10
        )
        set_response
      rescue TimeoutError #TODO
        p "rescue"
      end
    end

    def login
      begin
        @conn.write(Onlinenic::Request.login(@config))
        set_response
      rescue TimeoutError #TODO
        p "timeout error"
      rescue IOError
        initialize #reconnect and login again if connection is closed
      end
    end

    def logout
      begin
        @conn.write(Onlinenic::Request.logout(@config))
        set_response
        @conn.close
        true
      rescue TimeoutError #TODO
        p "timeout error"
      rescue IOError
        p "connection already closed"
      rescue Errno::EPIPE
        p "already logged out"
      end
    end

    def check_contact(contactid, domaintype)
      begin
        @conn.write(Onlinenic::Request.check_contact(@config, contactid, domaintype))
        set_response
        @response.get_data("avail")
      rescue TimeoutError #TODO
        p "timeout error"
      rescue IOError
        login
        check_contact(contactid, domaintype)
      rescue Errno::EPIPE #TODO
        p "Broken pipe"
      end
    end

    #returns contactid
    def create_contact(params)
#      params = {
#              :domaintype => "0",
#              :name => "emre",
#              :org => "YeniHayat",
#              :country => "US",
#              :province => "FL",
#              :city => "FLV",
#              :street => "No 1 Street 1",
#              :postalcode => "abcde",
#              :voice => "+1.3950160530",
#              :fax => "+1.3950160530",
#              :email => "fist@onlinenic.com",
#              :password => "5846213"
#      }
      begin
        @conn.write(Onlinenic::Request.create_contact(@config, params))
        set_response
        @response.get_data("contactid")
      rescue TimeoutError #TODO
        p "timeout error"
      rescue IOError
        login
        create_contact(params)
      rescue Errno::EPIPE #TODO
        p "Broken pipe"
      end
    end

    private

    #sets @response(Onlinenic::Response) attribute
    def set_response
      @response = Onlinenic::Response.new(@conn)
    end

  end
end