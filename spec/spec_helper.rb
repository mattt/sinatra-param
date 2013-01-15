unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
    add_filter '.bundle'
  end
end

require 'sinatra/param'
require 'rack/test'

require 'example/app'
