require 'sinatra/base'
require 'json'
require 'time'

class App < Sinatra::Base
  helpers Sinatra::Param

  before do
    content_type :json
  end

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
    param :sort, String, default: "title"
    params.to_json
  end

  get '/transform' do
    param :order, String, transform: :upcase
    params.to_json
  end

  # validations
  get '/validation/required' do
    param :arg, String, required: true
    params.to_json
  end

  get '/validation/blank/string' do
    param :arg, String, blank: false
  end

  get '/validation/blank/array' do
    param :arg, Array, blank: false
  end

  get '/validation/blank/hash' do
    param :arg, Hash, blank: false
  end

  get '/validation/blank/other' do
    param :arg, Class, blank: false
  end

  get '/validation/nonblank/string' do
    param :arg, String, blank: true
  end

  get '/validation/is' do
    param :arg, String, is: 'foo'
    params.to_json
  end

  get '/validation/in' do
    param :arg, String, in: ['ASC', 'DESC']
    params.to_json
  end

  get '/validation/within' do
    param :arg, Integer, within: 1..10
    params.to_json
  end

  get '/validation/range' do
    param :arg, Integer, range: 1..10
    params.to_json
  end

  get '/validation/min' do
    param :arg, Integer, min: 12
    params.to_json
  end

  get '/validation/max' do
    param :arg, Integer, max: 20
    params.to_json
  end

  get '/validation/min_length' do
    param :arg, String, min_length: 5
    params.to_json
  end

  get '/validation/max_length' do
    param :arg, String, max_length: 10
    params.to_json
  end

  get '/validation/error_code' do
    param :arg, String, required: true, error: 400
    params.to_json
  end

  get '/choice' do
    param :a, String
    param :b, String
    param :c, String

    one_of(:a, :b, :c)

    {
      message: 'OK'
    }.to_json
  end

  get '/choice/error_code' do
    one_of(:a, :b, :c, error: 400)
  end
end
