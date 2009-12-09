module Onlinenic
  class Connection

    attr_reader :response

    def initialize(opts={})
      @opts = { :auto_logout => true }.merge(opts)
      @wrapper = Onlinenic::Wrapper::Base.new
    end

    def check_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.check_domain({ :domain => domain.full_name, :domaintype => domain.type })
      logout if @opts[:auto_logout]
      @response.success? ? @response.get_data("avail") : @response.msg
    end

    def logout
      @wrapper.logout
    end
    
  end
end
