module Onlinenic
  module Plugin
    #This module is needed by install.rb and uninstall.rb
    module Requirements      
      require "lib/onlinenic/config"
      include Onlinenic::Config
    end
  end
end
