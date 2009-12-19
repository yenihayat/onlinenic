module Onlinenic
  class Connection

    PHONE_CODES = {
            "US" => "1",
            "TR" => "90"
    }

# commands to implement
#    COMMANDS = {
#            :check_contact        => "avail",
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

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def renew_domain(domain, period)
      domain = Onlinenic::Domain.new(domain)
      @response = @wrapper.renew_domain({ :domain => domain.full_name, :domaintype => domain.type, :period => period })
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
              :voice        => "+" + phone_code + "." + params[:voice], #params[:voice] must be :in => 5..12
              :fax          => "+" + phone_code + "." + params[:fax], #params[:fax] must be :in => 5..12
              :email        => params[:email],
              :password     => params[:password]
      })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response.get_data("contactid") : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response else returns nil
    #"country" is requiered to update "voice" or "fax".
    def update_contact(params={})
      params.symbolize_keys!
      phone_code = PHONE_CODES[params[:country]]
      args = {
              :domaintype   => Onlinenic::Domain.new(params[:domain]).type,
              :domain       => params[:domain],
              :contacttype  => params[:contacttpe],
              :name         => params[:name],
              :org          => params[:org],
              :country      => params[:country],
              :province     => params[:province],
              :city         => params[:city],
              :street       => params[:street],
              :postalcode   => params[:postalcode],
              :email        => params[:email],
              :password     => params[:password]
      }
      args.merge!({ :voice => "+" + phone_code + "." + params[:voice] }) if params[:voice] and phone_code
      args.merge!({ :fax => "+" + phone_code + "." + params[:fax] }) if params[:fax] and phone_code
      @response = @wrapper.update_contact(args)
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response : nil
    end

    #if command is successful returns Onlinenic::Wrapper::Response
    #else returns nil
    def change_registrant(params={})
      params.symbolize_keys!
      @response = @wrapper.change_registrant({
              :domaintype   => Onlinenic::Domain.new(params[:domain]).type,
              :domain       => params[:domain],
              :name         => params[:name],
              :org          => params[:org],
              :email        => params[:email]
      })
      logout if @opts[:auto_logout]
      @response.try(:success?) ? @response : nil
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
