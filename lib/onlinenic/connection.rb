module Onlinenic
  class Connection

    PHONE_CODES = {
            "US" => "1",
            "TR" => "90"
    }

#    COMMANDS = {
#            :check_contact        => "avail",
#            :update_contact       => "contactid",
#            :renew_domain         => nil,
#            :delete_domain        => nil,
#            :update_domain_status => nil,
#            :update_domain_extra  => nil,
#            :update_domain_dns    => nil,
#            :update_domain_pwd    => nil,
#            :info_domain_extra    => nil,
#            :get_auth_code        => "password",
#            :create_host          => nil,
#            :update_host          => nil,
#            :delete_host          => nil,
#            :info_id_shield       => nil
#    }

    attr_reader :response

    def initialize(opts={})
      opts.symbolize_keys!
      @opts = { :auto_logout => true }.merge(opts)
      @wrapper = Onlinenic::Wrapper::Base.new(Onlinenic::Config.get)
    end

    #logouts and closes the TCP connection
    def logout
      @wrapper.logout
    end

    #returns the "msg" value of response xml
    def message
      @response.try(:msg)
    end

    #-------------------------------------------------------------------------------
    #DOMAIN

    #if command is successful returns true or false
    #else returns nil
    def check_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.check_domain({ :domain => domain.full_name, :domaintype => domain.type })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response.get_data("avail").eql?("1") ? true : false : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def info_domain(domain)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.info_domain({ :domain => domain.full_name, :domaintype => domain.type })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def create_domain(params={})
      params.symbolize_keys!
      domain = Onlinenic::Domain.new(params[:domain])
      @response = @wrapper.create_domain({
              :domaintype => domain.type,
              :mltype     => domain.mltype,
              :domain     => domain.full_name,
              :period     => params[:period],
              :dns        => params[:dns],
              :registrant => params[:registrant],
              :tech       => params[:tech],
              :billing    => params[:billing],
              :admin      => params[:admin],
              :password   => params[:password]
      })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response : nil
    end

    #-------------------------------------------------------------------------------
    #CONTACT

    #if command is successful returns "contactid"
    #else returns nil
    def create_contact(params={})
      params.symbolize_keys!
      phone_code = PHONE_CODES[params[:country]]
      @response = @wrapper.create_contact({
              :domaintype   => Onlinenic::Domain.new(params[:domain]).type,
              :name         => params[:name],
              :org          => params[:org],
              :country      => params[:country],
              :province     => params[:province],
              :city         => params[:city],
              :street       => params[:street],
              :postalcode   => params[:postalcode],
              :voice        => "+" + phone_code + "." + params[:voice], #params[:voice] must be minimum 5 digit
              :fax          => "+" + phone_code + "." + params[:fax], #params[:fax] must be minimum 5 digit
              :email        => params[:email],
              :password     => params[:password]
      })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response.get_data("contactid") : nil
    end

    #-------------------------------------------------------------------------------
    #HOST

    #if command is successful returns true or false
    #else returns nil
    def check_host(hostname)
      params.symbolize_keys!
      domain = Onlinenic::Domain.new(hostname)
      @response = @wrapper.check_host({ :domaintype => domain.type, :hostname => hostname })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response.get_data("avail").eql?("1") ? true : false : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def info_host(hostname)
      domain = Onlinenic::Domain.new(hostname)
      @response = @wrapper.info_host({ :domaintype => domain.type, :hostname => hostname })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response : nil
    end

  end
end
