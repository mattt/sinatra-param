unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
    add_filter '.bundle'
  end
end

require 'sinatra/param'

require 'debugger'
require 'rspec'
require 'rack/test'

require 'dummy/app'

def app
  App
end

RSpec.configure do |c|
  c.include(Rack::Test::Methods)
end

ENV['TZ'] = 'UTC'
