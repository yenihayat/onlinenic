module Onlinenic
  class Domain

    SUPPORTED_DOMAIN_EXTENSIONS = {
            :com  => 0,
            :net  => 0,
            :org  => 807,
            :biz  => 800,
            :info => 805
    }

    attr_reader :full_name, :name, :extension, :type

    def initialize(domain)
      @full_name = domain
      @name, @extension = @full_name.split('.')
      @type = get_type(@extension)
    end

    private

    def get_type(extension)
      SUPPORTED_DOMAIN_EXTENSIONS[extension.to_sym]
    end

  end
end