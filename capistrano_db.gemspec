$:.push File.expand_path("../lib", __FILE__)
require "capistrano_db/version"

Gem::Specification.new do |gem|
  gem.authors       = ["nazarhussain"]
  gem.email         = ["nazarhussain@gmail.com"]
  gem.description   = %q{Helps you out to sync up you datbases between your local and server machines.}
  gem.summary       = %q{Helps you out to sync up you datbases between your local and server machines.}
  gem.homepage      = "nazarhussain.com"

  gem.files         = `git ls-files`.split("\n")
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.has_rdoc      = false
  gem.name          = "capistrano_db"
  gem.require_path = "lib"
  gem.version       = Capistrano::Db::VERSION
  gem.add_dependency "capistrano", [">= 2.9.0"]
end
