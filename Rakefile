require 'rubygems'
#require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "onlinenic"
    gem.summary     = "Ruby interface to Onlinenic.com's reseller API"
    gem.description = "This is a ruby interface to Onlinenic.com's reseller API. You can find API v2.0 documentation here: https://www.onlinenic.com/cp_english/template_api/download/ONLINENIC_API2.0.pdf"
    gem.email       = "info@yh.com.tr"
    gem.homepage    = "http://github.com/yenihayat/onlinenic"
    gem.authors     = ["Murat Demirten", "İzzet Emre Kutlu"]
    #gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

#require 'rake/testtask'
#Rake::TestTask.new(:test) do |test|
#  test.libs << 'lib' << 'test'
#  test.pattern = 'test/**/test_*.rb'
#  test.verbose = true
#end
#
#begin
#  require 'rcov/rcovtask'
#  Rcov::RcovTask.new do |test|
#    test.libs << 'test'
#    test.pattern = 'test/**/test_*.rb'
#    test.verbose = true
#  end
#rescue LoadError
#  task :rcov do
#    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
#  end
#end
#
#task :test => :check_dependencies
#
#task :default => :test
#
#require 'rake/rdoctask'
#Rake::RDocTask.new do |rdoc|
#  version = File.exist?('VERSION') ? File.read('VERSION') : ""
#
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title = "new_gem #{version}"
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end
