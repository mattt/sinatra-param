require 'spec_helper'

describe 'Parameter Validations' do
  describe 'required' do
    it 'returns 400 on requests without required fields' do
      get('/validation/required') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests when required field present' do
      get('/validation/required', arg: 'foo') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'blank' do
    it 'returns 400 on requests when string is blank' do
      get('/validation/blank/string', arg: '') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 400 on requests when array is blank' do
      get('/validation/blank/array', arg: '') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 400 on requests when hash is blank' do
      get('/validation/blank/hash', arg: '') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 400 on requests when hash is blank' do
      get('/validation/blank/other', arg: '') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on request when blank is true' do
      get('/validation/nonblank/string', arg: '') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'format' do
    it 'returns 200 on requests when value matches the param regex' do
      get('/validation/format/hello', arg: 'hello world') do |response|
        response.status.should eq(200)
      end
    end

    it 'returns 400 on requests when value does not match the param regex' do
      get('/validation/format/hello', arg: 'world') do |response|
        response.status.should eq(400)
      end
    end

    it 'returns 400 on requests when value is not a string' do
      get('/validation/format/9000', arg: 9000) do |response|
        response.status.should eq(400)
      end
    end
  end

  describe 'is' do
    it 'returns 400 on requests when value is other than defined' do
      get('/validation/is', arg: 'bar') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a value is other than defined' do
      get('/validation/is', arg: 'foo') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'in' do
    it 'returns 400 on requests with a value not in the set' do
      get('/validation/in', arg: 'MISC') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a value in the set' do
      get('/validation/in', arg: 'ASC') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'within' do
    it 'returns 400 on requests with a value outside the range' do
      get('/validation/within', arg: 20) do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a value within the range' do
      get('/validation/within', arg: 5) do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'range' do
    it 'returns 400 on requests with a value outside the range' do
      get('/validation/range', arg: 20) do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests within the range' do
      get('/validation/range', arg: 10) do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'min' do
    it 'returns 400 on requests with a value smaller than min' do
      get('/validation/min', arg: 5) do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a value larger than min' do
      get('/validation/min', arg: 200) do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'max' do
    it 'returns 400 on requests with a value larger than max' do
      get('/validation/max', arg: 100) do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a value smaller than max' do
      get('/validation/max', arg: 2) do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'min_length' do
    it 'returns 400 on requests with a string shorter than min_length' do
      get('/validation/min_length', arg: 'hi') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a string longer than min_length' do
      get('/validation/max_length', arg: 'longer') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'max_length' do
    it 'returns 400 on requests with a string longer than max_length' do
      get('/validation/max_length', arg: 'reallylongstringlongerthanmax') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with a string shorter than max_length' do
      get('/validation/max_length', arg: 'short') do |response|
        response.status.should eq(200)
      end
    end
  end

  describe 'required_keys' do
    it 'returns 400 on requests with a Hash without matching required_keys' do
      get('/validation/required_keys', arg: 'a:b') do |response|
        response.status.should eq(400)
        JSON.parse(response.body)['message'].should eq('Invalid Parameter: arg')
      end
    end

    it 'returns 200 on requests with matching required_keys' do
      get('/validation/required_keys', arg: 'c:d,d:f,g:h') do |response|
        response.status.should eq(200)
      end
    end
  end
end
