# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sinatra/param/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "sinatra-param"
  s.license     = "MIT"
  s.authors     = ["Mattt Thompson"]
  s.email       = "m@mattt.me"
  s.homepage    = "https://github.com/mattt/sinatra-param"
  s.version     = Sinatra::Param::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Parameter Validation & Type Coercion for Sinatra."
  s.description = "sinatra-param allows you to declare, validate, and transform endpoint parameters as you would in frameworks like ActiveModel or DataMapper."

  s.add_dependency "sinatra", "~> 1.3"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "simplecov"

  s.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
