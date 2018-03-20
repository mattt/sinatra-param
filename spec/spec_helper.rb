unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
    add_filter '.bundle'
  end
end

require 'sinatra/param'

require 'rspec'
require 'rack/test'

require 'dummy/app'
require 'dummy/app_with_flash'

def app
  App
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
