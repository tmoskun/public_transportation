# -*- encoding: utf-8 -*-
require File.expand_path('../lib/public_transportation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["tmoskun"]
  gem.email         = ["tanyamoskun@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "public_transportation"
  gem.require_paths = ["lib"]
  gem.version       = Transportation::VERSION
  gem.add_dependency('nori', '>=1.1')
  gem.add_dependency('rest-client', '>= 1.6')
  gem.add_dependency('geokit', '>= 1.6.5')
  gem.add_dependency('geo-distance', '>=0.2.0')
  gem.add_development_dependency('fakeweb')
  gem.add_development_dependency('minitest')
end
