module Onlinenic
  class Connection

    attr_reader :response

    def initialize
      @wrapper = Onlinenic::Wrapper.new
    end

    def check_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.check_domain({ :domain => domain.full_name, :domaintype => domain.type })
      @wrapper.logout
      @response.get_data("avail").eql?("1") ? true : false
    end

  end
end