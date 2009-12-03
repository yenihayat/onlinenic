module Onlinenic
  #This module is responsible for config file operations
  module Config
    require "fileutils"
    
    filename  = "onlinenic.yml"
    @dest     = File.expand_path("#{File.dirname(__FILE__)}/../../../../../config/#{filename}")
    @src      = filename

    #gets configuration options from config file
    def self.get(env = RAILS_ENV)
      YAML::load(IO.read(@dest))[env]
    end

    #copies config file unless it exists
    def self.copy
      if exists?
        p "Config file already initialized."
      else
        p "Initializing config file."
        FileUtils.cp(@src, @dest)
      end
    end

    #removes config file if it exists
    def self.remove
      if exists?
        p "Removing config file."
        FileUtils.rm(@dest)
      else
        p "Config file already removed."
      end
    end

    private

    #checks if config file exists
    def self.exists?
      File.exists?(@dest)
    end

  end
end