# -*- encoding: utf-8 -*-
require File.expand_path('../lib/uber_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "uber_model"
  gem.version       = UberModel::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Josh Williams"]
  gem.email         = ["jwilliams@shareone.com"]
  gem.description   = %q{Pseudo-ORM for Ruby/Rails with an ActiveRecord-like interface}
  gem.summary       = %q{Pseudo-ORM for Ruby}
  gem.homepage      = %q{http://github.com/t3hpr1m3/uber_model.git}
  gem.license       = %q{MIT}

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activemodel', '~> 3.1.12'
  gem.add_dependency 'rake'

  gem.add_development_dependency 'activerecord', '~> 3.1.12'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'libnotify'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'factory_girl'
  gem.add_development_dependency 'redcarpet'
end
