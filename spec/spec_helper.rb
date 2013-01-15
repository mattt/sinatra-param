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

include Rack::Test::Methods
