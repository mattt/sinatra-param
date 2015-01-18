require 'spec_helper'

describe 'Parameter' do
  it 'only sets parameters present in request or with a default value' do
    get('/', a: 'a', b: 'b') do |response|
      response_body = JSON.parse(response.body)
      expect(response_body).to be_member('a')
      expect(response_body).to be_member('b')
      expect(response_body).to be_member('c')
      expect(response_body).to_not be_member('d')
    end
  end

  it 'stringifies parameters' do
    get('/keys/stringify', q: 'test') do |response|
      expect(response.body).to eq 'TEST'
    end
  end
end
