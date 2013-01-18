# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "trigger-tasks"
  gem.version       = "0.0.1"
  gem.authors       = ["Mark Borcherding"]
  gem.email         = ["markborcherding@gmail.com"]
  gem.description   = %q{Rake tasks for a Trigger.io project}
  gem.summary       = %q{ A common set of tasks for a Trigger.io project. Tasks include building, package, and deploying to different locations, such as the device and TestFlight.  }
  gem.homepage      = "http://github.com/markborcherding/trigger-tasks"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('rake', '>= 9.x')
  gem.add_dependency('hashie')
  gem.add_dependency('highline')
  gem.add_dependency('rest-client')
end
