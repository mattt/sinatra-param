require 'spec_helper'

describe 'Parameter Sets' do
  describe 'only_one_of' do
    it 'returns 400 on requests that contain more than one mutually exclusive parameter' do
      params = [
        {a: 1, b: 2},
        {b: 2, c: 3},
        {a: 1, b: 2, c: 3}
      ]

      params.each do |param|
        get('/choice/3', param) do |response|
          expect(response.status).to eql 400
          expect(JSON.parse(response.body)['message']).to match(/mutually exclusive/)
        end
      end
    end

    it 'returns 400 on requests that contain more than one mutually exclusive parameter' do
      params = {a: 1, b: 2}

      get('/choice/2', params) do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to match(/mutually exclusive/)
      end
    end

    it 'returns successfully for requests that have one parameter' do
      params = [
        {a: 1},
        {b: 2},
        {c: 3}
      ]

      (1..3).each do |n|
        params.each do |param|
          get("/choice/#{n}", param) do |response|
            expect(response.status).to eql 200
            expect(JSON.parse(response.body)['message']).to match(/OK/)
          end
        end
      end
    end

    it 'returns successfully for requests that have no parameter' do
      (1..3).each do |n|
        get("/choice/#{n}") do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['message']).to match(/OK/)
        end
      end
    end
  end

  describe 'at_only_one_of' do
    it 'returns 200 on requests that contain at least one parameter' do
      params = [
        {a: 1, b: 2},
        {b: 2, c: 3},
        {a: 1, b: 2, c: 3}
      ]

      params.each do |param|
        get('/atleast', param) do |response|
          expect(response.status).to eql 200
        end
      end
    end

    it 'returns 400 on requests that do not contain any required parameters' do
      params = {d: 1}

      get('/atleast', params) do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to match(/At least one of the following parameters/)
      end
    end
  end
end
