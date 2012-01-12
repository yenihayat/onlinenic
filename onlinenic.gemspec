# gem build onlinenic.gemspec
Gem::Specification.new do |s|
  s.name        = 'onlinenic'
  s.version     = '0.1.0'
  s.date        = '2011-01-11'
  s.summary     = "Onlinenic"
  s.description = "Onlinenic"
  s.authors     = ["YeniHayat Bilisim"]
  s.email       = 'info@yh.com.tr'
	#s.files =  Dir.glob("{lib,spec}/**/*")
  s.files       = ["lib/onlinenic.rb", 
									 "lib/onlinenic/config.rb", 
									 "lib/onlinenic/connection.rb", 
									 "lib/onlinenic/domain.rb", 
									 "lib/onlinenic/wrapper/base.rb", 
									 "lib/onlinenic/wrapper/request.rb", 
									 "lib/onlinenic/wrapper/response.rb",
									 "tasks/onlinenic_tasks.rake",
									 "README.markdown",
									 "MIT_LICENCE",
									 "Rakefile",
									 "onlinenic.yml",
	]
	s.require_path = "lib"
  s.homepage    = 'http://rubygems.org/gems/onlinenic'
end
