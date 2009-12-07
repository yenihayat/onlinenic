module Onlinenic
  #Request XML Format
  #
  #  <?xml version="1.0"?>
  #  <request>
  #    <category>CATEGORY</category>          Operation category: "client" | "domain" | "account". The value of CATEGORY must be one of three categories above.
  #    <action>ACTION</action>                Action: the type of designated action. For example, login means for login operation, infoHost means the DNS query.
  #    <params>                               Parametes.
  #      <param name=”PARAM1”>VALUE1</param>  Parameters1
  #      <param name=”PARAM2”>VALUE2</param>  Parameters2
  #      ......                               .......
  #      <param name=”PARAMn”>VALUEn</param>  ParametersN
  #    </params>
  #    <cltrid>CLTRID</cltrid>                Order number which is generated by customer and must be unique.
  #    <chksum>CHKSUM</chksum>                CHKSUM info. Md5 secret key between reseller and ONlineNIC.
  #  </request>

  class Request

    CATEGORIES = {
            :client => "client",
            :domain => "domain"
    }

    ACTIONS = {
            :login                => { :name => "Login", :checksum => { :name => "login" } },
            :logout               => { :name => "Logout", :checksum => { :name => "logout" } },
            :create_contact       => { :name => "CreateContact", :category => :domain, :checksum => { :name => "crtcontact", :extra => [:name, :org, :email] } },
            :check_contact        => { :name => "CheckContact", :category => :domain, :checksum => { :name => "checkcontact", :extra => [:domaintype, :contactid] } },
            :update_contact       => { :name => "UpdateContact", :category => :domain, :checksum => { :name => "updatecontact", :extra => [:domaintype, :domain, :contacttype] } },
            :check_domain         => { :name => "CheckDomain", :category => :domain, :checksum => { :name => "checkdomain", :extra => [:domaintype, :domain] } },
            :info_domain          => { :name => "InfoDomain", :category => :domain, :checksum => { :name => "infodomain", :extra => [:domaintype, :domain] } },
            :create_domain        => { :name => "CreateDomain", :category => :domain, :checksum => { :name => "createdomain", :extra => [:domaintype, :domain, :period, :dns, :registrant, :admin, :tech, :billing, :password] } },
            :renew_domain         => { :name => "RenewDomain", :category => :domain, :checksum => { :name => "renewdomain", :extra => [:domaintype, :domain, :period] } },
            :delete_domain        => { :name => "DeleteDomain", :category => :domain, :checksum => { :name => "deldomain", :extra => [:domaintype, :domain] } },
            :update_domain_status => { :name => "UpdateDomainStatus", :category => :domain, :checksum => { :name => "updatedomainstatus", :extra => [:domaintype, :domain] } },
            :update_domain_extra  => { :name => "UpdateDomainExtra", :category => :domain, :checksum => { :name => "updatedomainextra", :extra => [:domaintype, :domain] } },
            :update_domain_dns    => { :name => "UpdateDomainDns", :category => :domain, :checksum => { :name => "updatedomaindns", :extra => [:domaintype, :domain] } },
            :update_domain_pwd    => { :name => "UpdateDomainPwd", :category => :domain, :checksum => { :name => "updatedomainpwd", :extra => [:domaintype, :domain, :password] } },
            :info_domain_extra    => { :name => "InfoDomainExtra", :category => :domain, :checksum => { :name => "infodomainextra", :extra => [:domaintype, :domain] } },
            :get_auth_code        => { :name => "GetAuthcode", :category => :domain, :checksum => { :name => "getauthcode", :extra => [:domaintype, :domain] } },
            :check_host           => { :name => "CheckHost", :category => :domain, :checksum => { :name => "checkhost", :extra => [:domaintype, :hostname] } },
            :info_host            => { :name => "InfoHost", :category => :domain, :checksum => { :name => "infohost", :extra => [:domaintype, :hostname] } },
            :create_host          => { :name => "CreateHost", :category => :domain, :checksum => { :name => "createhost", :extra => [:domaintype, :hostname, :addr] } },
            :update_host          => { :name => "UpdateHost", :category => :domain, :checksum => { :name => "updatehost", :extra => [:domaintype, :hostname, :addaddr, :remaddr] } },
            :delete_host          => { :name => "DeleteHost", :category => :domain, :checksum => { :name => "deletehost", :extra => [:domaintype, :hostname, :addaddr, :remaddr] } }            
    }

    class << self

      def login(config)
        create_request(config, CATEGORIES[:client], ACTIONS[:login], :clid => config["account"])
      end

      def logout(config)
        create_request(config, CATEGORIES[:client], ACTIONS[:logout])
      end

      ACTIONS.except(:login, :logout).each_pair do |k, v|
        define_method(k) do |config, params|
          create_request(config, CATEGORIES[v[:category]], ACTIONS[k], params)
        end
      end

      private

      def create_request(config, category, action, params={})
        cltrid = create_cltrid
        xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
        xml << "<request>"
        xml << "<category>#{category}</category>"
        xml << "<action>#{action[:name]}</action>"
        if params
          xml << "<params>"
          params.each_pair do |k, v|
            if v.kind_of?(Array)
              v.each do |e|
                xml << "<param name=\"#{k}\">#{e}</param>"
              end
            else
              xml << "<param name=\"#{k}\">#{v}</param>"
            end
          end
          xml << "</params>"
        end
        xml << "<cltrid>#{cltrid}</cltrid>"
        xml << "<chksum>#{checksum(config, cltrid, action[:checksum], params)}</chksum>"
        xml << "</request>"
      end

      def create_cltrid
        Digest::MD5.hexdigest(Time.now.to_s + rand.to_s)[0..20]
      end

      def checksum(config, cltrid, action, params)
        suffix = action[:name].dup
        action[:extra].try(:each) do |e|
          suffix << params[e].to_s
        end
        Digest::MD5.hexdigest(config["account"].to_s + Digest::MD5.hexdigest(config["password"]) + cltrid + suffix)
      end

    end

  end
end