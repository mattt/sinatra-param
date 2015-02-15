require 'spec_helper'

describe 'Parameter Sets' do
  describe 'any_of' do
    it 'returns 400 on requests that contain fewer than one required parameter' do
      get('/any_of', {}) do |response|
        expect(response.status).to eql 400
        expect(JSON.parse(response.body)['message']).to match(/Invalid parameters/)
      end
    end

    it 'returns successfully for requests that have at least one parameter' do
      params = [
        {a: 1},
        {b: 2},
        {c: 3},
        {a: 1, b: 2},
        {b: 2, c: 3},
        {a: 1, b: 2, c: 3}
      ]

      params.each do |param|
        get("/any_of", param) do |response|
          expect(response.status).to eql 200
          expect(JSON.parse(response.body)['message']).to match(/OK/)
        end
      end
    end
  end
end
