require 'spec_helper'

describe 'Parameter Sets' do
  describe 'one_of *groups' do
    it 'returns 400 on requests that contain more than one mutually exclusive parameter' do
      params = [
        {a: 1, b: 2, c: 3}
      ]

      params.each do |param|
        get('/choice/groups', param) do |response|
          expect(response.status).to eql 400
          expect(JSON.parse(response.body)['message']).to match(/mutually exclusive/)
        end
      end
    end

    it 'returns successfully for requests that have one parameter' do
      params = [
        {a: 1},
        {b: 2},
        {c: 3},
        {a: 1, b: 2},
        {a: 1, c: 3},
        {b: 2, c: 3}
      ]

      params.each do |param|
        get('/choice/groups', param) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['message']).to match(/OK/)
        end
      end
    end

    it 'returns successfully for requests that have no parameter' do
      get('/choice/groups') do |response|
        expect(response.status).to eql 200
        expect(JSON.parse(response.body)['message']).to match(/OK/)
      end
    end
  end
end
