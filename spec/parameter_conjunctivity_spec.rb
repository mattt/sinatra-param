require 'spec_helper'

describe 'Parameter Sets' do
  describe 'all_or_none_of' do
    it 'returns 400 on requests that have some but not all required parameters' do
      params = [
        {a: 1},
        {b: 2, c: 3},
        {a: 1, c: 3},
      ]

      params.each do |param|
        get('/all_or_none_of', param) do |response|
          expect(response.status).to eql 400
          expect(JSON.parse(response.body)['message']).to match(/^Invalid parameters/)
        end
      end
    end

    it 'returns successfully for requests that have all parameters' do
      param = {a: 1, b: 2, c: 3}

      response = get("/all_or_none_of", param)
      expect(response.status).to eql 200
      expect(JSON.parse(response.body)['message']).to match(/OK/)
    end

    it 'returns successfully for requests that have none of the parameters' do
      response = get("/all_or_none_of")
      expect(response.status).to eql 200
      expect(JSON.parse(response.body)['message']).to match(/OK/)
    end
  end
end
