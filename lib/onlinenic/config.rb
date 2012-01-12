module Onlinenic
  #This module is responsible for config file operations
  module Config
    require "fileutils"
    
    FILENAME  = "onlinenic.yml"
    #@dest     = File.expand_path("#{File.dirname(__FILE__)}/../../../../../config/#{filename}")
		#@dest     = File.join(Rails.root, "config", "onlinenic.yml")
    @src      = File.expand_path("#{File.dirname(__FILE__)}/../../#{FILENAME}")

		def self.dest
			@dest ||= File.join(Rails.root, "config", "onlinenic.yml")
		end

    #gets configuration options from config file
    def self.get(env = Rails.env)
      YAML::load(IO.read(self.dest))[env]
    end

    #copies config file unless it exists
    def self.copy
      if exists?
        p "Config file already initialized."
      else
        p "Initializing config file. Check Rails.root/config/onlinenic.yml"
        FileUtils.cp(@src, self.dest)
      end
    end

    #removes config file if it exists
    def self.remove
      if exists?
        p "Removing config file."
        FileUtils.rm(self.dest)
      else
        p "Config file already removed."
      end
    end

    private

    #checks if config file exists
    def self.exists?
      File.exists?(self.dest)
    end

  end
end
