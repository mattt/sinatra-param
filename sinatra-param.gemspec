# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra/param"

Gem::Specification.new do |s|
  s.name        = "sinatra-param"
  s.authors     = ["Mattt Thompson"]
  s.email       = "m@mattt.me"
  s.homepage    = "http://github.com/mattt/sinatra-param"
  s.version     = Sinatra::Param::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "sinatra-param"
  s.description = "Parameter Contracts for Sinatra"
  
  s.add_dependency "sinatra",   "~> 1.3"

  s.add_development_dependency "rspec", "~> 0.6.1"
  s.add_development_dependency "rake",  "~> 0.9.2"

  s.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
