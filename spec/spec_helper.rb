unless ENV['CI']
  require 'simplecov'
	require 'simplecov-cobertura'
	SimpleCov.start do
		add_filter '/spec/'
		add_filter '.bundle'
		minimum_coverage(70)
		coverage_dir "#{Dir.pwd}/build/reports"
		SimpleCov.formatters = [
			SimpleCov::Formatter::HTMLFormatter,
			SimpleCov::Formatter::CoberturaFormatter
		]
	end
end



require 'sinatra/param'

require 'rspec'
require 'rack/test'

require 'dummy/app'

def app
  App
end

include Rack::Test::Methods
