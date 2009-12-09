module Onlinenic
  class Connection

#    COMMANDS = {
#            :check_contact        => "avail",
#            :create_contact       => "contactid",
#            :update_contact       => "contactid",
#            :check_domain         => "avail",
#            :info_domain          => nil,
#            :create_domain        => nil,
#            :renew_domain         => nil,
#            :delete_domain        => nil,
#            :update_domain_status => nil,
#            :update_domain_extra  => nil,
#            :update_domain_dns    => nil,
#            :update_domain_pwd    => nil,
#            :info_domain_extra    => nil,
#            :get_auth_code        => "password",
#            :check_host           => "avail",
#            :info_host            => nil,
#            :create_host          => nil,
#            :update_host          => nil,
#            :delete_host          => nil,
#            :info_id_shield       => nil
#    }

    attr_reader :response

    def initialize(opts={})
      @opts = { :auto_logout => true }.merge(opts)
      @wrapper = Onlinenic::Wrapper::Base.new
    end

    #if command is successful returns true or false
    #else returns nil
    def check_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.check_domain({ :domain => domain.full_name, :domaintype => domain.type })
      logout if @opts[:auto_logout]
      @response.success? ? @response.get_data("avail").eql?("1") ? true : false : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def info_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.info_domain({ :domain => domain.full_name, :domaintype => domain.type })
      logout if @opts[:auto_logout]
      @response.success? ? @response : nil
    end


    def logout
      @wrapper.logout
    end

  end
end
