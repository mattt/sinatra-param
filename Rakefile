require "bundler"
Bundler.setup

gemspec = eval(File.read("sinatra-param2.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["sinatra-param2.gemspec"] do
  system "gem build sinatra-param2.gemspec"
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
end
