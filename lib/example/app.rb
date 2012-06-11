require 'sinatra/base'
require 'json'

require_relative '../sinatra/param'

class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end
  
  # GET /messages
  # GET /messages?sort=name&order=ASC
  get '/messages' do
    param :sort,  String, default: "name"
    param :order, String, in: ["ASC", "DESC"], transform: :upcase, default: "ASC"
    
    {
      sort: params[:sort],
      order: params[:order]
    }.to_json
  end
  
  # GET /messages/1,2,3,4,5
  get '/messages/:ids' do
    param :ids, Array, required: true
    
    {
      ids: params[:ids]
    }.to_json
  end
  
  # POST /messages/1/response
  post '/messages/:id/response' do
    param :message, String, max: 1024, required: true
    
    {
      message: params[:message]
    }.to_json
  end

  get '/exclude' do
    param :a, String
    param :b, String
    param :c, String
    param_mutex(:a, :b)
    param_mutex(:b, :c)
    {
      message: 'OK'
    }.to_json
  end
end

