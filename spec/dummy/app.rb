require 'sinatra/base'
require 'json'
require 'time'

class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

  # coercion
  get '/coerce/string' do
    params[:arg] = params[:arg].to_i
    param :arg, String
    params.to_json
  end

  get '/coerce/integer' do
    param :arg, Integer
    params.to_json
  end

  get '/coerce/float' do
    param :arg, Float
    params.to_json
  end

  get '/coerce/time' do
    param :arg, Time
    params.to_json
  end

  get '/coerce/date' do
    param :arg, Date
    params.to_json
  end

  get '/coerce/datetime' do
    param :arg, DateTime
    params.to_json
  end

  get '/coerce/array' do
    param :arg, Array
    params.to_json
  end

  get '/coerce/hash' do
    param :arg, Hash
    params.to_json
  end

  get '/coerce/boolean' do
    param :arg, :boolean
    params.to_json
  end

  # transformations
  get '/default' do
    param :sort,        String, default: "title"
    params.to_json
  end

  get '/transform' do
    param :order,       String, transform: :upcase
    params.to_json
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

  # GET /choice?a=foo
  # GET /choice?b=bar
  # GET /choice?c=baz
  get '/choice' do
    param :a, String
    param :b, String
    param :c, String

    one_of(:a, :b, :c)

    {
      message: 'OK'
    }.to_json
  end
end
