require 'spec_helper'

describe 'Parameter Types' do
  describe 'String' do
    it 'coerces strings' do
      get('/coerce/string', arg: '1234') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to eq('1234')
      end
    end
  end

  describe 'Integer' do
    it 'coerces integers' do
      get('/coerce/integer', arg: '1234') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to eq(1234)
      end
    end

    it 'returns 400 on requests when integer is invalid' do
      get('/coerce/integer', arg: '123abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'123abc' is not a valid Integer")
      end
    end
  end

  describe 'Float' do
    it 'coerces floats' do
      get('/coerce/float', arg: '1234') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to eq(1234.0)
      end
    end

    it 'returns 400 on requests when float is invalid' do
      get('/coerce/float', arg: '123abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'123abc' is not a valid Float")
      end
    end
  end

  describe 'Time' do
    it 'coerces time' do
      get('/coerce/time', arg: '20130117') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to match(/2013-01-17 00:00:00/)
      end
    end

    it 'returns 400 on requests when time is invalid' do
      get('/coerce/time', arg: 'noon') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'noon' is not a valid Time")
      end
    end
  end

  describe 'Date' do
    it 'coerces date' do
      get('/coerce/date', arg: '20130117') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to eq('2013-01-17')
      end
    end

    it 'returns 400 on requests when date is invalid' do
      get('/coerce/date', arg: 'abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'abc' is not a valid Date")
      end
    end
  end

  describe 'DateTime' do
    it 'coerces datetimes' do
      get('/coerce/datetime', arg: '20130117') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to eq('2013-01-17T00:00:00+00:00')
      end
    end

    it 'returns 400 on requests when datetime is invalid' do
      get('/coerce/datetime', arg: 'abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'abc' is not a valid DateTime")
      end
    end
  end

  describe 'Array' do
    it 'coerces arrays' do
      get('/coerce/array', arg: '1,2,3,4,5') do |response|
        expect(response.status).to eql 200
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['arg']).to be_an(Array)
        expect(parsed_body['arg']).to eq(%w(1 2 3 4 5))
      end
    end

    it 'coerces arrays of size 1' do
      get('/coerce/array', arg: '1') do |response|
        expect(response.status).to eql 200
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['arg']).to be_an(Array)
        expect(parsed_body['arg']).to eq(%w(1))
      end
    end

    it 'coerces arrays with arg[] style' do
      get('/coerce/array', 'arg[]' => ['1','2','3','4','5']) do |response|
        expect(response.status).to eql 200
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['arg']).to be_an(Array)
        expect(parsed_body['arg']).to eq(%w(1 2 3 4 5))
      end
    end
  end

  describe 'Hash' do
    it 'coerces hashes' do
      get('/coerce/hash', arg: 'a:b,c:d') do |response|
        expect(response.status).to eql 200
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['arg']).to be_an(Hash)
        expect(parsed_body['arg']).to eq({ 'a' => 'b', 'c' => 'd'})
      end
    end
  end

  describe 'File' do
    let(:arg) { Rack::Test::UploadedFile.new(content, 'text/csv', original_filename: 'file.csv') }
    let(:content) { StringIO.new('content') }
    let(:head) do
      <<~HEAD
        Content-Disposition: form-data; name="arg"; filename="file.csv"\r
        Content-Type: text/csv\r
        Content-Length: 7\r
      HEAD
    end

    it 'coerces files' do
      put('/coerce/file', arg: arg) do |response|
        expect(response.status).to eql 200
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['arg']).to be_a(Hash)
        expect(parsed_body['arg']).to eq({
          'body' => 'content',
          'content_type' => 'text/csv',
          'filename' => 'file.csv',
          'head' => head,
          'name' => 'arg',
          'original_filename' => 'file.csv',
          'type' => 'text/csv',
        })
      end
    end

    it 'returns 400 when not a hash' do
      put('/coerce/file', arg: 'arg') do |response|
        expect(response.status).to eql 400
      end
    end

    it 'returns 400 when not a file upload hash' do
      put('/coerce/file', arg: { 'a' => 'a' }) do |response|
        expect(response.status).to eql 400
      end
    end
  end

  describe 'Boolean' do
    it 'coerces truthy booleans to true' do
      %w(1 true t yes y).each do |bool|
        get('/coerce/boolean', arg: bool) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['arg']).to be true
        end
      end
    end

    it 'coerces falsey booleans to false' do
      %w(0 false f no n).each do |bool|
        get('/coerce/boolean', arg: bool) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['arg']).to be false
          expect(JSON.parse(response.body)['arg']).to_not be_nil
        end
      end
    end

    it 'coerces truthy booleans to true when default is false' do
      %w(1 true t yes y).each do |bool|
        get('/default/boolean/false', arg: bool) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['arg']).to be true
        end
      end
    end

    it 'coerces falsey booleans to false when default is true' do
      %w(0 false f no n).each do |bool|
        get('/default/boolean/true', arg: bool) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['arg']).to be false
          expect(JSON.parse(response.body)['arg']).to_not be_nil
        end
      end
    end

    it 'coerces default booleans to true when default is true and its not provided' do
      get('/default/boolean/true') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to be true
        expect(JSON.parse(response.body)['arg']).to_not be_nil
      end
    end

    it 'coerces default booleans to false when default is false and its not provided' do
      get('/default/boolean/false') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['arg']).to be false
        expect(JSON.parse(response.body)['arg']).to_not be_nil
      end
    end

    it 'returns 400 on requests when true is not a truthy value' do
      get('/default/boolean/true', arg: 'abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'abc' is not a valid boolean")
      end
    end

    it 'returns 400 on requests when false is not a falsey value' do
      get('/default/boolean/false', arg: 'abc') do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to eq("'abc' is not a valid boolean")
      end
    end
  end
end
