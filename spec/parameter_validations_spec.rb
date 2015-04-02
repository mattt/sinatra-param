require 'spec_helper'

describe 'Parameter Validations' do
  describe 'required' do
    it 'returns 400 on requests without required fields' do
      get('/validation/required') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter is required")
      end
    end

    it 'returns 200 on requests when required field present' do
      get('/validation/required', arg: 'foo') do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'blank' do
    it 'returns 400 on requests when string is blank' do
      get('/validation/blank/string', arg: '') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be blank")
      end
    end

    it 'returns 400 on requests when array is blank' do
      get('/validation/blank/array', arg: '') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be blank")
      end
    end

    it 'returns 400 on requests when hash is blank' do
      get('/validation/blank/hash', arg: '') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be blank")
      end
    end

    it 'returns 400 on requests when hash is blank' do
      get('/validation/blank/other', arg: '') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be blank")
      end
    end

    it 'returns 200 on request when blank is true' do
      get('/validation/nonblank/string', arg: '') do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'format' do
    it 'returns 200 on requests when value matches the param regex' do
      get('/validation/format/hello', arg: 'hello world') do |response|
        expect(response.status).to eq(200)
      end
    end

    it 'returns 400 on requests when value does not match the param regex' do
      get('/validation/format/hello', arg: 'world') do |response|
        expect(response.status).to eq(400)
      end
    end

    it 'returns 400 on requests when value is not a string' do
      get('/validation/format/9000', arg: 9000) do |response|
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'is' do
    it 'returns 400 on requests when value is other than defined' do
      get('/validation/is', arg: 'bar') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter must be foo")
      end
    end

    it 'returns 200 on requests with a value is other than defined' do
      get('/validation/is', arg: 'foo') do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'in' do
    it 'returns 400 on requests with a value not in the set' do
      get('/validation/in', arg: 'MISC') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter must be within [\"ASC\", \"DESC\"]")
      end
    end

    it 'returns 200 on requests with a value in the set' do
      get('/validation/in', arg: 'ASC') do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'within' do
    it 'returns 400 on requests with a value outside the range' do
      get('/validation/within', arg: 20) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter must be within 1..10")
      end
    end

    it 'returns 200 on requests with a value within the range' do
      get('/validation/within', arg: 5) do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'range' do
    it 'returns 400 on requests with a value outside the range' do
      get('/validation/range', arg: 20) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter must be within 1..10")
      end
    end

    it 'returns 200 on requests within the range' do
      get('/validation/range', arg: 10) do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'min' do
    it 'returns 400 on requests with a value smaller than min' do
      get('/validation/min', arg: 5) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be less than 12")
      end
    end

    it 'returns 200 on requests with a value larger than min' do
      get('/validation/min', arg: 200) do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'max' do
    it 'returns 400 on requests with a value larger than max' do
      get('/validation/max', arg: 100) do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot be greater than 20")
      end
    end

    it 'returns 200 on requests with a value smaller than max' do
      get('/validation/max', arg: 2) do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'min_length' do
    it 'returns 400 on requests with a string shorter than min_length' do
      get('/validation/min_length', arg: 'hi') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot have length less than 5")
      end
    end

    it 'returns 200 on requests with a string longer than min_length' do
      get('/validation/max_length', arg: 'longer') do |response|
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'max_length' do
    it 'returns 400 on requests with a string longer than max_length' do
      get('/validation/max_length', arg: 'reallylongstringlongerthanmax') do |response|
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq("Parameter cannot have length greater than 10")
      end
    end

    it 'returns 200 on requests with a string shorter than max_length' do
      get('/validation/max_length', arg: 'short') do |response|
        expect(response.status).to eq(200)
      end
    end
  end
end
