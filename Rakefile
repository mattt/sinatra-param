require "bundler"
Bundler.setup

gemspec = eval(File.read("sinatra-param.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["sinatra-param.gemspec"] do
  system "gem build sinatra-param.gemspec"
end
