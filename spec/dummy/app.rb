require 'sinatra/base'
require 'sinatra/param'
require 'date'
require 'time'
require 'json'

class App < Sinatra::Base
  helpers Sinatra::Param

  set :show_exceptions, false
  set :raise_errors, true

  before do
    content_type :json
  end

  get '/' do
    param :a, String
    param :b, String, required: true
    param :c, String, default: 'test'
    param :d, String

    params.to_json
  end

  get '/keys/stringify' do
    param :q, String, transform: :upcase

    params['q']
  end

  get '/coerce/string' do
    params['arg'] = params['arg'].to_i
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
    param :arg, Boolean
    params.to_json
  end

  get '/default' do
    param :sort, String, default: "title"
    params.to_json
  end

  get '/default/hash' do
    param :attributes, Hash, default: {}
    params.to_json
  end

  get '/default/proc' do
    param :year, Integer, default: proc { 2014 }
    params.to_json
  end

  get '/default/boolean/true' do
    param :arg, Boolean, default: true
    params.to_json
  end

  get '/default/boolean/false' do
    param :arg, Boolean, default: false
    params.to_json
  end

  get '/transform' do
    param :order, String, transform: :upcase
    params.to_json
  end

  get '/transform/required' do
    param :order, String, required: true, transform: :upcase
    params.to_json
  end

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

  get '/validation/format/9000' do
    param :arg, Integer, format: /9000/
    params.to_json
  end

  get '/validation/format/hello' do
    param :arg, String, format: /hello/
    params.to_json
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

  get '/one_of/1' do
    param :a, String
    param :b, String
    param :c, String

    one_of :a

    {
      message: 'OK'
    }.to_json
  end

  get '/one_of/2' do
    param :a, String
    param :b, String
    param :c, String

    one_of :a, :b

    {
      message: 'OK'
    }.to_json
  end

  get '/one_of/3' do
    param :a, String
    param :b, String
    param :c, String

    one_of :a, :b, :c

    {
      message: 'OK'
    }.to_json
  end

  get '/any_of' do
    param :a, String
    param :b, String
    param :c, String

    any_of :a, :b, :c

    {
      message: 'OK'
    }.to_json
  end

  get '/raise/validation/required' do
    param :arg, String, required: true, raise: true
    params.to_json
  end

  get '/raise/one_of/3' do
    param :a, String
    param :b, String
    param :c, String

    one_of :a, :b, :c, raise: true

    {
      message: 'OK'
    }.to_json
  end

  get '/raise/any_of' do
    param :a, String
    param :b, String
    param :c, String

    any_of :a, :b, :c, raise: true

    {
      message: 'OK'
    }.to_json
  end
end
