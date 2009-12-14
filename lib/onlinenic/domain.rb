module Onlinenic
  class Domain

    SUPPORTED_DOMAIN_EXTENSIONS = {
            :com  => 0,
            :net  => 0,
            :biz  => 800,
            :name => 804,
            :info => 805,
            :us	  => 806,
            :org  => 807,
            :me	  => 906
    }

    attr_reader :full_name, :name, :extension, :type, :mltype

    def initialize(domain)
      set_full_name(domain)
      #@name, @extension = @full_name.split('.')
      array       = @full_name.split('.')
      @extension  = array.pop
      @name       = array.join('.')
      @type       = get_type(@extension)
      @mltype     = get_mltype
    end

    private

    def get_type(extension)
      SUPPORTED_DOMAIN_EXTENSIONS[extension.to_sym]
    end

    def set_full_name(domain)
      @full_name = domain
      @full_name.gsub!(/^http:\/\//, '')
      @full_name.gsub!(/^https:\/\//, '')
      @full_name.gsub!(/^www./, '')
    end

    def get_mltype
      "0"
    end

  end
end
