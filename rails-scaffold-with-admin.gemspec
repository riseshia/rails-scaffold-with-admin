# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_scaffold_with_admin/version'

Gem::Specification.new do |spec|
  spec.name          = "rails-scaffold-with-admin"
  spec.version       = RailsScaffoldWithAdmin::VERSION
  spec.authors       = ["Shia"]
  spec.email         = ["rise.shia@gmail.com"]

  spec.summary       = "Rails admin scaffolding generator"
  spec.description   = "Rails generator which allows to scaffold admin controllers, views, models, helpers, tests and routes."
  spec.homepage      = "https://github.com/riseshia/rails-scaffold-with-admin"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", [">= 4.0"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
