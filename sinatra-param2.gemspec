# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra/param/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "sinatra-param2"
  s.license     = "MIT"
  s.authors     = ["Mattt Thompson", "Adrian Bravo"]
  s.email       = "adrianbn@gmail.com"
  s.homepage    = "https://github.com/adrianbn/sinatra-param2"
  s.version     = Sinatra::Param::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Parameter Validation & Type Coercion for Sinatra."
  s.description = "sinatra-param2 allows you to declare, validate, and transform endpoint parameters as you would in frameworks like ActiveModel or DataMapper."

  s.add_dependency "sinatra", "~> 2.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-cobertura"

  s.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
