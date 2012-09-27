$:.push File.expand_path("../lib", __FILE__)
require "capistrano_db/version"

Gem::Specification.new do |gem|
  gem.authors       = ["nazarhussain"]
  gem.email         = ["nazarhussain@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split("\n")
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.has_rdoc      = false
  gem.name          = "capistrano_db"
  gem.require_path = "lib"
  gem.version       = Capistrano::Db::VERSION
  gem.add_dependency "capistrano", [">= 2.9.0"]
end
